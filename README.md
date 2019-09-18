dot\_scr
========

by Greg Kennedy, 2019

What Is It?
-----------

dot\_scr is a Perl process that records DOSBox movies of Windows 3.1 screensavers, and posts to Twitter.

You may [**see the bot on Twitter here**](https://twitter.com/dot_scr).

You can [**view the list of supported screensavers here**](MASTER_LIST.md).

How It Works
------------

The main entry point for the process is `main.pl`, which coordinates all other moving parts to produce these videos. The high level procedure is:

+ Choose a screensaver "unit" (driver class) from the collection of available units
+ Unpack a fresh Windows 3.1 installation from .zip, as well as the "payload" for the screensaver we wish to run
+ Run an edit function for config files in the staging area, setting the screensaver to launch and applying Windows themes
+ Launch (headless) a patched DOSBox binary, which is hacked to begin recording at a certain time and then exit after some duration
+ Use FFmpeg to compress the output into something suitable for Twitter
+ Upload the result video and post it in a tweet

The rest of this document describes these steps in detail.

Units
-----

A Screensaver unit, stored in the `Unit` folder, is a "driver" or "wrapper" for one or more screensavers. A Unit is a Perl module that describes a class. Units are dynamically loaded at run-time,
having a predefined `info()` function that can be called without instantiation to get info about the unit. These are logical groupings: there is one unit
for each of the Windows default screensavers, and then there is one large unit for _all_ the After Dark 1.0 screensavers.

A sample info for SSSTARS (Starfield Simulation) looks like this:

    (
        name     => 'SSSTARS',
        fullname => 'Starfield Simulation',
        author   => 'Microsoft',
        weight   => 1,
        payload  => ['MICROSOFT.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&append_controlini,
        },
        dosbox   => {
            start => 8000,
            cycles => 0
        },
    )

`name`, `fullname` and `author` are self-explanatory.  
`weight` is used for random selection to make a unit more likely: if omitted, it defaults to 1. For example, `AFTERDRK.pm` sets this high, because it contains multiple sub-modules.  
`payload` is an array of files to deploy (unzip) into the staging area.  
`files` is a hash of filenames to modify using the line-by-line text replacement tool. The values are function references, which will replace lines or append new ones.  
`files_custom` (not shown) is similar to `files`, but requires the unit to do all the reading/writing internally. It's used to edit binary files or more complicated configuration.  
`dosbox` is a list of details relevant to DOSBox emulation: the two recognized keys are `start` (milliseconds before triggering recording start) and `cycles` (fixed cycles to run at, 0 for MAX)

Once all available units are checked and info retrieved, a unit is selected randomly, and the staging area is created by unpacking payloads into a temp folder.

Unit instantiation via `new()` should cause the unit to pick all target values for configuration, and return a blessed hash. Some units check the staging area for files first,
e.g. AFTERDRK which needs a list of installed units.

The only other required method is `detail()` which returns a human-readable settings string: this becomes part of the final Twitter post.

Theme Unit
------------

In the root folder and ALWAYS loaded, there is a Theme unit called `Theme.pm`. It is similar to a cut-down version of a Screensaver unit: it uses the Edit functions
to make changes to the Windows environment before launch. Specifically, it sets the Windows wallpaper, pattern, and Windows color scheme from a list of available files.

Edit Config
-----------

Before launch the units often need to make changes to config files in the staging area, mainly to enable a specific screensaver or adjust configuration. Regardless of the method used, files
are ALWAYS backed up to a `source/` folder in the temp folder first, then rewritten into the staging area. There are two ways to edit files:

**Text file editing (`files` key)**  
Each file in the `files` hash is opened by the main script and read in, line-by-line. Each line is passed to the function reference: the function should either edit the line or return it unchanged. At
the end of the file a final call is made with `undef` as the line: here the function may return any string to append to the end of the file.

This is mainly useful for editing Windows .ini files: for example this function from `SSSTARS.pm` alters a line in `SYSTEM.INI` to call the correct screensaver:

    sub edit_systemini {
        my ( $self, $line ) = @_;
    
        if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
            $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSSTARS.SCR";
        }
        return $line;
    }

**Custom file editing (`files_custom` key)**  
Each file in the `files` hash is passed to the referenced function. The function receives a source and destination filename. It is the job of the calling function to open, write, and close the files
as needed. This is used for binary file editing: see `AFTERDRK.pm` for some example usage.

Payloads
--------

The `payload` list contains all the .zip files to be extracted into the staging area. **Always, the first payload extracted is `__main__.zip`**: this payload contains a stripped-down Windows 3.11 installation
with Sound Blaster 16 drivers, and a Paradise SVGA card at 640x480 256colors.

Each .zip is unpacked in order and files may overwrite those already extracted. Please note the directory structure should be carefully maintained.

Payloads do not necessarily correspond to Units in a 1:1 manner - for example, there are five Units for the built-in Windows screensavers, but all are collected together into one payload called `MICROSOFT.zip`.

The unzip code is loosely based on [this example Gist from eqhmcow](https://gist.github.com/eqhmcow/5389877).

Patched DOSBox
--------------

Now it is time to launch the emulator and capture the screenshot. DOSBox has an excellent video recording method that captures pixel-perfect sequences into a custom codec. Unfortunately, the vanilla source
requires a key combination to trigger recording, which does a headless unattended server no good.

In order to make this work, there is a patch `dosbox-0.74-3_demo-record.patch` which can be applied against the 0.74-3 source release .tar.gz. This patch adds two new entries to the dosbox.conf file:

+ demostart (time, in milliseconds, to trigger video recording)
+ demolength (time, in milliseconds after demo start, to stop recording and terminate DOSBox)

The actual implementation is a hack and will not be passed upstream :P

`dosbox.conf` is edited to change the `demostart` and `cycles` parameters. Then on launch, the autoexec rules will mount a folder as the root C:\ drive and start Windows.
From here the system simply waits for the screensaver to begin, starts recording, and then exits two minutes later.

DOSBox is built on SDL 1.2, a cross-platform library for accessing a variety of video, sound, input, and other interfaces for writing games. SDL applications can support multiple output methods (e.g. 2d acceleration, 3d OpenGL, DirectX, AAlib). When we run DOSBox, the script selects a "dummy" output driver for both video and sound. These sinks create no output window or sound, allowing the application to run at full speed headless without regard for installed hardware. The actual execution command is `SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy ./dosbox`.

FFmpeg
------

The output video, `capture/KRNL386_000.avi`, uses the ZMBV codec for lossless encoding and PCM\_S16 audio. Neither of these are accepted by Twitter's video upload. Videos instead must be:

+ MP4 container
+ H.264 video codec, YUV420p pixel format, max 1920x1080 or so
+ AAC audio (low complexity)
+ 140 seconds maximum length
+ 512MB maximum size

To meet these constrains `ffmpeg` is called with command line arguments. First, to fall within the upload limit, we compute a maximum bitrate by dividing 256MB by video length. Next, to
preserve color detail despite chroma subsampling, the video resolution is doubled using nearest-neighbor scaling (up to 1280x960). If the unit indicates sound was enabled, an AAC stream
is created at 192kbps (or omitted entirely, if the screensaver makes no sound). Output is stored in the same capture dir with a .mp4 extension.

256MB over 140sec gives a very generous 14Mbit/s rate, but in practice the rate is often FAR less while achieving lossless quality. Most screensaver scenes contain a lot of static elements
or solid color areas.

Twitter::API
------------

The final piece is getting the video online. For this there is [Twitter::API](https://metacpan.org/pod/Twitter::API). Setting up the bot, getting a developer account and app, and generating
the key and secret is beyond the scope of this README.

Twitter::API has a helpful trait called `ApiMethods`, but the endpoint methods generated don't cover the uploading process. Instead we simply construct all requests by hand instead.

Uploading a video to Twitter is a multi-step process:

1. POST to media/upload.json with command 'INIT' and some basic file info. This gives a `media_id`: keep that for later.
2. Repeatedly POST to media/upload.json with command 'APPEND'. This endpoint accepts the video in blocks up to 5MB long: larger files must be chunked and uploaded in pieces.
3. Once everything's done, POST to media/upload.json with command 'FINALIZE'. This will generally return a 'processing\_info' entry with state, progress, and a time delay.
4. Until the state is 'failed' or 'succeeded', repeatedly wait `delay` seconds, then GET media/upload.json with command 'STATUS' and check the progress.
5. Once processing is complete, compose a tweet with the `media_id` attached. The message is freeform text and we populate it with the Screensaver name, author, and settings info.
6. If the selected unit has a `followup()` method, call that and post it as a reply to the first tweet. This is used for cases where there is too much data to fit into one tweet.
See `SSMARQUE.pm` for example usage.

License
-------

Note that **none of the files in `payload/` are free software**. All copyright belongs to the original owners. They may not be legally redistributed.

All other code in this repository is released under the Perl Artistic 2.0 license. See `LICENSE.md` for more information.

