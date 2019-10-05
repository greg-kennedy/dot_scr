package Unit::INTERM40;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Intermission 4.0

my %modules = (
    'Acid Spray' => {
        cfg => {
            'Blank'      => [ 'n', 'y' ],
            'Size Drops' => [ 10,  28, 40 ],
            'Num Drops' => [ 1 .. 50 ],
        }
    },
    'Ant Mine' => {
        cfg => {
            'Show Border' => [ 0, 1 ],
            'Num Ants'    => [ 1 .. 20 ],
            'Num Tunnels' => [ 1 .. 5 ],
            'Blank After' => 600,
        }
    },
    'Battling Mixers' => {
        sound => 1,
        cfg   => {
            'Num Mixers'   => [ 2, 4, 6, 8, 10 ],
            'Mixer Sound'  => 1,
            'Enable Sound' => 1,
        }
    },
    'Bigfoot' => {
        sound => 1,
        cfg   => {
            'Colored Feet' => [ 0, 1 ],
            'Speed' => [ 0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000 ],
            'Sound' => 1,
            'Closed Captioned' => [ 0, 1 ],
        }
    },
    'Bitmap Saver' => {
        cfg => {
            'Num Bitmaps'  => [ 0 .. 100 ],
            'Bitmap Speed' => 0,
            'Bitmap Path'  => {
                'type' => 'bmp',
                'path' => 'WINDOWS',
            }
        }
    },
    'Bricks' => {
        sound => 1,
        cfg   => {
            'Use Paddle'    => 0,
            'Always Follow' => [ 0, 1 ],
            'Use Screen'    => [ 0, 1 ],
            'Use Sound'     => 1,
            'Paddle Speed'  => [ 1 .. 20 ],
            'Min Speed'     => [ 1 .. 20 ],
            'Max Speed'     => [ 1 .. 20 ],
        }
    },
    'Chaos' => {
        cfg => {
            'Large Dots'   => [ 0, 1 ],
            'Color Change' => [
                40,   80,   120,  160,  200,  240,  280,  320,  360,  400,
                440,  480,  520,  560,  600,  640,  680,  720,  760,  800,
                840,  880,  920,  960,  1000, 1040, 1080, 1120, 1160, 1200,
                1240, 1280, 1320, 1360, 1400, 1440, 1480, 1520, 1560, 1600,
                1640, 1680, 1720, 1760, 1800, 1840, 1880, 1920, 1960, 2000,
                2040, 2080, 2120, 2160, 2200, 2240, 2280, 2320, 2360, 2400,
                2440, 2480, 2520, 2560, 2600, 2640, 2680, 2720, 2760, 2800,
                2840, 2880, 2920, 2960, 3000, 3040, 3080, 3120, 3160, 3200,
                3240, 3280, 3320, 3360, 3400, 3440, 3480, 3520, 3560, 3600,
                3640, 3680, 3720, 3760, 3800, 3840, 3880, 3920, 3960, 4000
            ],
            'Multiplier' => [ 0 .. 100 ],
            'Clear secs' => [
                681050122, 681050132, 681050142, 681050152,
                681050162, 681050172, 681050182, 681050192,
                681050202, 681050212, 681050222, 681050232,
                681050242, 681050252,
            ],
        }
    },
    'Clowns' => {
        sound => 1,
        cfg   => {}
    },
    'Communique' => {
        cfg => {
            'Speed' => [ 1 .. 20 ],
            'Scrolling Text' => [ 0 .. 2],
            'Current Message' => [ 0 .. 4 ],
            # these have to be copied from the defaults or else you get a generic
            #  "Intermission" message
            'Message0' => 'Arial,20,B,L,Intermission!!',
            'Message1' => "Helv,32,B,R,Out\xFF\xFETo\xFF\xFELunch",
            'Message2' => 'System,15,U,L,My other computer is a Cyber',
            'Message3' => "Helv,12,,C,Back in\xFF\xFE10 Minutes.",
            'Message4' => 'Courier,20,BI,L,Leave a Message'
            # TODO: Message5, with random size and other stuff
        }
    },
    'Conundrum' => {
        sound => 1,
        cfg   => {
            'Sound' => 'y',
            'Speed' => [ 1 .. 20 ],
            'Size'  => [ 0 .. 3 ],
        }
    },
    'Cowboy Singer' => {
        sound => 1,
        cfg   => {}
    },
    'Crystal Palettes' => {
        cfg => {
            'Step Size'   => [ 1 .. 20 ],
            'Max Size'    => [ 20 .. 200 ],
            # TODO at least one of these should be enabled
            'Rectangles?' => [ 0, 1 ],
            'Circles?'    => [ 0, 1 ],
            'Triangles?'  => [ 0, 1 ],
            'RoundRects?' => [ 0, 1 ],
            'Palette'     => [ 123 .. 126 ],
            'Background?' => [ 0, 1 ],
        }
    },
    'Dancing Pig' => {
        sound => 1,
        cfg   => {}
    },
    'Dissolve' => {
        cfg => {
            'Cycle'         => 'y',
            'Fade to Black' => [ 'n', 'y' ],
        }
    },
    'Dragon Kites' => {
        sound => 1,
        cfg   => {
            'Kite strings' => [ 'no', 'yes' ],
            'Smooth kites' => [ 'no', 'yes' ],
            'Beach Sounds' => 'yes',
            'Kites'        => [ 1 .. 16 ],
            'Turbulence'   => [ 0 .. 25 ],
        }
    },
    'Einstein' => {
        cfg => {
            'Where' => [ 1, 2, 4 ],
            'Blank' => [ 0, 1 ]
        }
    },
    'Eyes' => {
        sound => 1,
        cfg   => {
            'Num Eyes'  => [ 2 .. 25 ],
            'Speed'     => [ 1 .. 10 ],
            'Bloodshot' => [ 'n', 'y' ],
            'Sound'     => 'y',
        }
    },

    #'Fade Out' => {}
    'Ferns' => {
        cfg => {
            'Blank after'          => [ 1 .. 15 ],
            # TODO at least one should be enabled
            'Spring/Summer Colors' => [ 0, 1 ],
            'Fall Colors'          => [ 0, 2 ],
            'Winter Colors'        => [ 0, 4 ],
        }
    },
    'Firefly' => {
        sound => 1,
        cfg   => {
            "Number 'O Bugs" => [ 5 .. 50 ],
            'Enable Sounds'  => 1,
        }
    },
    'Fireworks' => {
        sound => 1,
        cfg   => {
            'Missiles' => [
                10,  20,  30,  40,  50,  60,  70,  80,  90,  100,
                110, 120, 130, 140, 150, 160, 170, 180, 190, 200,
                210, 220, 230, 240, 250, 260, 270, 280, 290, 300
            ],
            'Clear after' => [ 1 .. 10 ],
            'Trail color' => [ 1 .. 10 ],
            'Trails'      => {
                'type' => 'flags',
                'length' => 5,
                'values' => [ '0', '1' ],
            },
            'Bouncing missiles' => [ 'n', 'y' ],
            'Launch sparks'     => [ 'n', 'y' ],
            'Sound'             => 'y',
        }
    },
    'Flashlight' => {
        cfg => {
            'Size' => [
                30,  40,  50,  60,  70,  80,  90,  100, 110, 120,
                130, 140, 150, 160, 170, 180, 190, 200, 210, 220,
                230, 240, 250, 260, 270, 280, 290, 300
            ],
            'Speed' => [ 1 .. 20 ],
        }
    },
    'Flex' => {
        cfg => {
            'Speed' => [
                0,  5,  10, 15, 20, 25, 30, 35, 40, 45, 50, 55,
                60, 65, 70, 75, 80, 85, 90, 95, 100
            ],
            'Length' => [
                1 .. 10, 15,  20,  25,  30,  35,  40,  45,
                50,      60,  70,  80,  90,  100, 110, 120,
                130,     140, 150, 160, 170, 180, 190, 200
            ],
            'New color' => [
                36,   100,  200,  300,  400,  500,  600,  700,
                800,  900,  1000, 1100, 1200, 1300, 1400, 1500,
                1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300,
                2400, 2500, 2600, 2700, 2800, 2900, 3000
            ],
            'New shape' => [
                1 .. 10, 20,   30,   40,   50,   75,   100,  250,
                500,     750,  1000, 1500, 2000, 2500, 3000, 3500,
                4000,    4500, 5000, 5500, 6000, 6500, 7000, 8000,
                9000,    9999
            ],
            'Shapes' => {
                'type' => 'flags',
                'length' => 10,
                'values' => [ '0', '1' ],
                'one_set' => 1,
            },
            'Fading' => [ 'n', 'y' ],
        }
    },
    'Flow' => {
        cfg => {
            'num points'       => [ 1 .. 5 ],
            'wave freq.'       => [ 1 .. 5 ],
            'screen time'      => 1,
            'final resolution' => [ 1, 2, 4, 8 ],
            'pattern'          => [ 139 .. 142 ],
            'pre-chosen'       => [ 0 .. 2 ],
            # todo: these should never be all-0, but the odds of that happening are incredibly slim
            'custom-red'       => [ 0, 1 ],
            'custom-orange'    => [ 0, 1 ],
            'custom-yellow'    => [ 0, 1 ],
            'custom-green'     => [ 0, 1 ],
            'custom-blue'      => [ 0, 1 ],
            'custom-purple'    => [ 0, 1 ],
            'palette-name #'   => [ 0 .. 29 ],
        }
    },
    'Flying' => {
        cfg => {
            'Where' => [ 1, 2, 4 ],
            'Blank' => [ 0, 1 ]
        }
    },
    'Golfing Ants' => {
        sound => 1,
        cfg   => {}
    },
    'Ice Crystals' => {
        cfg => {
            'Animate'    => [ 0, 1 ],
            'Num Points' => [
                1 .. 10, 15, 20,  25,  30,  35,  40, 45,
                50,      75, 100, 150, 200, 250, 500
            ],
            'Blank Delay' => [
                0,   5,    10,   15,   20,  25,  30,  40,  50,  60,
                75,  90,   105,  120,  150, 180, 210, 240, 270, 300,
                330, 360,  390,  420,  450, 480, 510, 540, 570, 600,
                900, 1200, 1500, 1800, 3600
            ],
        }
    },
    'Kaleidoscope' => {
        cfg => {
            'Rainbow'      => [ 'n', 'y' ],
            'Color Bgd'    => [ 'n', 'y' ],
            'Min Group'    => [ 1 .. 999 ],
            'Max Group'    => [ 1 .. 999 ],
            'Min Blanking' => [ 1 .. 9999 ],
            'Max Blanking' => [ 1 .. 9999 ],
            'Panels'       => [ 1,   4, 9, 16, 25, 36, 49, 64, 81, 100 ],
        }
    },
    'Marine' => {
        sound => 1,
        cfg   => {
            'Population' => [ 1 .. 25 ],
            'Anemones'   => [ 0 .. 10 ],
            'Coral'      => [ 0 .. 10 ],
            'Shells'     => [ 0 .. 10 ],
            'Bubbles'    => [ 0, 1 ],
            'Sea Floor'  => [ 'n', 'y' ],
            'Scrolldown' => [ 'n', 'y' ],
            'Types'      => {
                'type' => 'flags',
                'length' => 17,
                'values' => [ '0', '1' ],
                'one_set' => 1,
            },
            'Sound'      => 'y',
        }
    },
    'Maze' => {
        cfg => {
            'Cell Size'     => [ 5 .. 60 ],
            'Max Cell Size' => [ 5 .. 60 ],
            'Solve Speed'   => [ 0, 25, 50, 75, 100 ],
            'Solve Color'   => [ 0 .. 14 ],
            'Mouse'         => [ 0, 1 ],
            'Smart Solve'   => [ 0, 1 ],
            'Show Timer'    => [ 0, 1 ],
            'Show Visit'    => [ 0 .. 2 ],
            'User Solve'    => 0,
        }
    },
    'Melting Screen' => {
        cfg => {
            'Color Delay' => [
                50,  60,  75,  90,   105,  120,  150, 180, 210, 240,
                270, 300, 330, 360,  390,  420,  450, 480, 510, 540,
                570, 600, 900, 1200, 1500, 1800, 3600
            ],
        }
    },
    'Moire A' => {
        cfg => {
            'Color Count' => [
                1 .. 10, 15,   20,   25,   30,   35,   40,   45,
                50,      75,   100,  150,  200,  250,  500,  1000,
                1500,    2000, 2500, 3000, 3500, 4000, 4500, 5000,
                10000
            ],
            'Clear Count' => [
                100,  200,  300,  400,  500,  600,  700,  800,
                900,  1000, 1100, 1200, 1300, 1400, 1500, 1600,
                1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400,
                2500, 2600, 2700, 2800, 2900, 3000, 3100, 3200,
                3300, 3400, 3500, 3600, 3700, 3800, 3900, 4000,
                4100, 4200, 4300, 4400, 4500, 4600, 4700, 4800,
                4900, 5000, 5100, 5200, 5300, 5400, 5500, 5600,
                5700, 5800, 5900, 6000, 6100, 6200, 6300, 6400,
                6500, 6600, 6700, 6800, 6900, 7000, 7100, 7200,
                7300, 7400, 7500, 7600, 7700, 7800, 7900, 8000,
                8100, 8200, 8300, 8400, 8500, 8600, 8700, 8800,
                8900, 9000, 9100, 9200, 9300, 9400, 9500, 9600,
                9700, 9800, 9900, 10000
            ],
            'Multiplier' => [
                4,   8,   12,  16,  20,  24,  28,  32,  36,  40,
                44,  48,  52,  56,  60,  64,  68,  72,  76,  80,
                84,  88,  92,  96,  100, 104, 108, 112, 116, 120,
                124, 128, 132, 136, 140, 144, 148, 152, 156, 160,
                164, 168, 172, 176, 180, 184, 188, 192, 196, 200
            ],
        }
    },
    'Moire B' => {
        cfg => {
            'Color Change' => [
                1 .. 10, 15,   20,   25,   30,   35,   40,   45,
                50,      75,   100,  150,  200,  250,  500,  1000,
                1500,    2000, 2500, 3000, 3500, 4000, 4500, 5000,
                10000
            ],
            'Max Speed'    => [ 1 .. 20 ],
            'Number'       => [ 1 .. 20 ],
            'Trail Length' => [
                0 .. 10, 15,   20,   25,   30,   35,   40,   45,
                50,      75,   100,  150,  200,  250,  500,  1000,
                1500,    2000, 2500, 3000, 3500, 4000, 4500, 5000,
                10000
            ],
        }
    },
    'Mosaic' => {
        cfg => {
            'Num tiles' => [ 1 .. 32 ],
        }
    },
    'Orbs' => {
        cfg => {
            'Clear after' =>
              [ 0 .. 10, 15, 20, 25, 30, 35, 40, 45, 50, 75, 100 ],
        }
    },

    #'Palette Animator' => {
    # sound => 1,
    #  cfg => {
    #  'Animate' => 1,
    #  'Blank' => 0,
    #  'Sound Enabled' => 1,
    #  'Clut Number' => [0 .. 30],
    #  'Animate Speed' => [1 .. 10],
    #  'Sonud Delay' => 0,
    #  'Sound Directory' => 'C:\\WINDOWS',
    #  'Sound Files' => 'chimes.wav chord.wav ding.wav tada.wav',
    #} },
    'Paradise' => {
        cfg => {}
    },
    'Photo Shoot' => {
        cfg => {
            'Change Every'  => 60,
            'Original Size' => 1,
            'Random Order'  => 1,
        }
    },
    'Picture Show' => {
        cfg => {
            'Where to Draw'      => [ 'c', 'r', 'u' ],
            'Picture Show Path'  => 'C:\\WINDOWS',
            'Picture Show Speed' => [ 5, 10, 15 ],
            'ForceBoxFade'       => [ 0, 1 ],
            'Fade In'            => [ 0, 1 ],
            'Fade Out'           => [ 0, 1 ],
        }
    },
    'Ping' => {
        sound => 1,
        cfg   => {
            'Random Speeds' => [ 0, 1 ],
            'Always Follow' => [ 0, 1 ],
            'Show Score'    => [ 0, 1 ],
            'Use Sound'     => 1,
            'Play Computer' => 0,
            'Min Speed'     => [ 1, 20 ],
            'Max Speed'     => [ 1, 20 ],
            'Paddle Speed'  => [ 1, 20 ],
        }
    },
    'Plants' => {
        cfg => {
            'Num Generations'    => [ 1 .. 10 ],
            'Space between Buds' => [ 1 .. 20 ],
            'Leaf Type'          => [ 116, 117 ],
        }
    },
    'Polar Caps' => {
        cfg => {
            'Trail Length' => [
                0 .. 10, 15, 20,  25,  30,  35,  40,  45,
                50,      75, 100, 150, 200, 250, 500, 1000
            ],
            'Number' => [ 1 .. 4 ],
            'Size'   => [ 1 .. 10 ],
        }
    },
    'Rapping Pig' => {
        sound => 1,
        cfg   => {}
    },
    'Snooze' => {
        sound => 1,
        cfg   => {}
    },
    'Snow Flakes' => {
        cfg => {
            'Max Velocity' => [ 1 .. 50 ],
            'Num Flakes'   => [ 1 .. 50 ],
        }
    },
    'Sorcery' => {
        cfg => {
            'Num Sticks' => [
                10,  20,  30,  40,  50,  60,  70,  80,  90,  100,
                110, 120, 130, 140, 150, 160, 170, 180, 190, 200,
                210, 220, 230, 240, 250, 260, 270, 280, 290, 300,
                310, 320, 330, 340, 350, 360, 370, 380, 390, 400,
                410, 420, 430, 440, 450, 460, 470, 480, 490, 500,
                510, 520, 530, 540, 550, 560, 570, 580, 590, 600,
                610, 620, 630, 640, 650, 660, 670, 680, 690, 700,
                710, 720, 730, 740, 750, 760, 770, 780, 790, 800,
                810, 820, 830, 840, 850, 860, 870, 880, 890, 900,
                910, 920, 930, 940, 950, 960, 970, 980, 990, 1000
            ],
        }
    },

    #'Space Shark' => {
    # sound => 1,
    #  cfg => {
    #  'Sound' => 1,
    #  'Difficult' => [0, 1],
    #} },
    'Spirals' => {
        cfg => {
            'Num Spirals' => [ 0 .. 100 ],
            'Fill Type'   => [ 0 .. 2 ],
            'Animate'     => [ 0, 1 ],
        }
    },
    'Swarm' => {
        sound => 1,
        cfg   => {
            'WaspWidth'      => [ 1 .. 4 ],
            'Wasps'          => [ 1 .. 5 ],
            'MaxWaspSpeed'   => [ 1 .. 24 ],
            'MaxWaspAccel'   => [ 1 .. 24 ],
            'Bees'           => [ 1 .. 128 ],
            'MaxBeeSpeed'    => [ 1 .. 24 ],
            'MaxBeeAccel'    => [ 1 .. 24 ],
            'Chase Closest'  => [ 'no', 'yes' ],
            'Rainbow Colors' => [ 'no', 'yes' ],
            'Enable Sound'   => 'yes'
        }
    },
    'Swirl' => {
        cfg => {
            'Width'   => [ 1 .. 10, 15, 20, 25 ],
            'Speed'   => [ 1 .. 10 ],
            'Reverse' => [ 'n', 'y' ],
        }
    },
    'The Machine (Palette)' => {
        cfg => {}
    },
    'Timepiece' => {
        sound => 1,
        cfg => {
            'Size' => [
                30,  40,  50,  60,  70,  80,  90,  100, 110, 120,
                130, 140, 150, 160, 170, 180, 190, 200, 210, 220,
                230, 240, 250, 260, 270, 280, 290, 300
            ],
            'Sounds'    => '111111',
            'Jumping'   => [ 'n', 'y' ],
            'Jump time' => [
                5,  10, 15, 20, 25, 30, 35, 40,  45,  50,  55,  60,
                65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120
            ],
            'Colors'            => {
                'type' => 'flags',
                'length' => 5,
                'values' => [ '0' .. '9', 'A' .. 'F' ],
            },
            'Show face'         => [ 'n', 'y' ],
            'Show second hand'  => [ 'n', 'y' ],
            'Show minute marks' => [ 'n', 'y' ],
            'Show hour marks'   => [ 'n', 'y' ],
            'Clip face'         => [ 'n', 'y' ],
            'Solid face'        => [ 'n', 'y' ],
            'Bitmap path'       => {
                'type' => 'bmp',
                'path' => 'SAVER',
            }
        }
    },
    'Tunnel' => {
        cfg => {
            'Speed1'   => [ 1 .. 10 ],
            'Reverse1' => [ 'n', 'y' ],
            'Colors1'  => {
                'type' => 'flags',
                'length' => 6,
                'values' => [ '0', '1' ],
                'one_set' => 1,
            },
            'Speed2'   => [ 1 .. 10 ],
            'Reverse2' => [ 'n', 'y' ],
            'Colors2'  => {
                'type' => 'flags',
                'length' => 6,
                'values' => [ '0', '1' ],
            },
            'Shape'    => [ 0 .. 3 ],
        }
    },
    'Wriggly' => {
        sound => 1,
        cfg   => {
            'Number of worms'    => [ 1 .. 20 ],
            'Number of segments' => [ 1 .. 20 ],
            'Wiggle frequency'   => [ 0 .. 100 ],
            'Wiggle Amount'      => [ 0 .. 8 ],
            'Size of worm'       => [ 1 .. 3 ],
            'Sound'              => 1,
        }
    },
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'INTERM40',
        fullname => 'Intermission 4.0',
        author   => 'Delrina Software',
        payload  => ['INTERM40.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI' => \&edit_systemini,
            'WINDOWS/WIN.INI'    => \&edit_winini,
            'WINDOWS/ANTSW.INI'  => \&edit_antswini,
        },
        dosbox => {
            start  => 18000,
            cycles => 5000
        },

        weight => scalar keys %modules,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    # parse the module input file
    open( my $fpi, '<:crlf', "$basepath/WINDOWS/ANTSW.INI" )
      or die "Couldn't open antsw.ini: $!";
    my $sec = '';
    my $id  = 0;
    while ( my $line = <$fpi> ) {
        if ( $line =~ m/\[Intermission Extensions\]/i ) {
            $sec = 'ext';
        } elsif ( $line =~ m/^\[/ ) {
            $sec = '';
        } elsif ( $sec eq 'ext' ) {
            if ( $line =~ m/^(.+)=(.+)$/ ) {
                my $ini_modfilename = $1;
                my ( $ini_modunk, $ini_modname, $ini_modext, $ini_modpath ) =
                  split /~/, $2;
                if ( exists $modules{$ini_modname} ) {
                    $modules{$ini_modname}{id} = $id;
                } else {
                    print "Skipping unknown module $ini_modname ($ini_modfilename)\n";
                }
                $id++;
            }
        }
    }
    close $fpi;

    # choose module (name)
    my $module = _pick( keys %modules );
    if ( !defined $modules{$module}{id} ) {
        die "Error: selected module $module but no ID exists!";
    }
    # Configuration only happens for non-MultiModule entries
    my $cfg     = '';
    my $cfg_str = '';
    my $sound;

    foreach my $ctl_name ( keys %{ $modules{$module}{cfg} } ) {
        my $value;
        my $control = $modules{$module}{cfg}{$ctl_name};
        if ( ref $control eq 'HASH' ) {
            # Special cased generators
            if ($control->{type} eq 'flags') {
                # Set of flags from a list
                #  "length" is how many, "values" is the list of choices,
                #  "one_set" means "at least one must be non-zero"
                my $unset_val = $control->{values}[0];

                my $one_set;
                do {
                  $one_set = 0;
                  $value = '';
                  for (my $i = 0; $i < $control->{length}; $i ++) {
                    my $j = _pick ( @{$control->{values}} );
                    if ($j ne $unset_val) { $one_set = 1 }
                    $value .= $j;
                  }
                } while ($control->{one_set} && ! $one_set);
              $cfg_str .= ", $ctl_name: $value";
            } elsif ($control->{type} eq 'bmp') {
              # pick a BMP at random from within the path
              opendir( my $dh, $basepath . '/' . $control->{path} );
              my @files = readdir($dh);
              closedir($dh);

              my @bmps;
              foreach my $file (@files) {
                  if ( $file =~ m/^.+\.bmp$/i ) {
                      push @bmps, $file;
                  }
              }

              # Pick today's winner
              my $bmp = _pick(@bmps);
              $value = "C:\\" . $control->{path} . "\\" . $bmp;
              $cfg_str .= ", $ctl_name: $bmp";
            } else {
              die "Unknown param generator type '$control->{type}'";
            }
        } elsif ( ref $control eq 'ARRAY' ) {
            # Array means there is a choice, so we should
            #  add detail to the tweet too
            $value = _pick( @{ $control } );
            $cfg_str .= ", $ctl_name: $value";
        } else {

            # No array = hardcoded value, no sense adding to
            #  settings desc
            $value = $control;
        }

        $cfg .= "$ctl_name=$value\n";
    }

    my $self = {
        module      => $module,
        id          => $modules{$module}{id},
        settings    => $cfg,
        description => $cfg_str,
        sound       => $modules{$module}{sound}
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "Module: " . $self->{module} . $self->{description};
}

##############################################################################

sub edit_systemini {
    my ( $self, $line ) = @_;

    # append the 386 driver
    if ( $line && $line =~ m/^\[386Enh\]$/i ) {
        $line .= "\ndevice=ANTHOOK.386";
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^load=(.*)$/ ) {
        $line = "load=c:\\saver\\intermis.exe $1";
    }

    return $line;
}

sub edit_antswini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
        if ( $line =~ m/^Saver Selected=/i ) {
            $line = "Saver Selected=$self->{id}";
        }
    } else {
        $line = "[$self->{module}]\n" . $self->{settings};
    }

    return $line;
}

1;

