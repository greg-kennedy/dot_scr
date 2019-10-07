package Unit::Common::Microsoft;
use strict;
use warnings;

our %palette = (
  Black   => "0 0 0",
  Maroon  => "128 0 0",
  Green   => "0 128 0",
  Olive   => "128 128 0",
  Navy    => "0 0 128",
  Purple  => "128 0 128",
  Teal    => "0 128 128",
  Gray    => "128 128 128",
  Silver  => "192 192 192",
  Red     => "255 0 0",
  Lime    => "0 255 0",
  Yellow  => "255 255 0",
  Blue    => "0 0 255",
  Fuchsia => "255 0 255",
  Aqua    => "0 255 255",
  White   => "255 255 255",
);

our %ext_palette = (
  %palette,

  # extra colors
  'Medium Gray' => "160 160 164",
  'Money Green' => "192 220 192",
  'Sky Blue'    => "166 202 240",
  'Cream'       => "255 251 240"
);

# TODO: Font names and sizes should be moved into a separate fuction, with
#  Font::TTF parsing at launch time instead.
our @font_faces = (
  'Arial',
  'Arial Narrow',
  'Augsburger Initials',
  'Baskerville Old Face',
  'Bell MT',
  'Book Antiqua',
  'Bookman Old Style',
  'Braggadocio',
  'BriemScript',
  'Britannic Bold',
  'Castellar',
  'Centaur',
  'Century Gothic',
  'Century Schoolbook',
  'Contemporary Brush',
  'Courier New',
  'Desdemona',
  'Eckmann',
  'Edda',
  'Elephant',
  'Eurostile',
  'Futura',
  'Gill Sans Ultra Bold',
  'Gradl',
  'Harrington',
  'Impact',
  'Lucida Blackletter',
  'Lucida Bright',
  'Lucida Bright Math Extension',
  'Lucida Bright Math Italic',
  'Lucida Bright Math Symbol',
  'Lucida Calligraphy',
  'Lucida Fax',
  'Lucida Handwriting',
  'Lucida Sans',
  'Lucida Sans Typewriter',
  'Mistral',
  'Monotype Corsiva',
  'Monotype Sorts',
  'New Caledonia',
  'Old English Text MT',
  'Onyx',
  'Parade',
  'Peignot Medium',
  'Playbill',
  'Ransom',
  'Stencil',
  'Stop',
  'Symbol',
  'Times New Roman',
  'Wide Latin',
  'Wingdings',
  'Wingdings 2',
  'Wingdings 3',
);

our @font_sizes
  = ( 8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48, 72 );

1;
