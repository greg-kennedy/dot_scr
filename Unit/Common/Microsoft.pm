package Unit::Common::Microsoft;
use strict;
use warnings;

our @patterns = (
    "(None)",   "Boxes",   "Paisley",  "Weave",    "Waffle", "Tulip",
    "Spinner",  "Scottie", "Critters", "50% Gray", "Quilt",  "Diamonds",
    "Thatches", "Pattern",
);

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

our @font_sizes =
  ( 8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48, 72 );

our %themes = (
    'Windows Default' => [
        'A0A0A4', 'FFFFFF', 'FFFFFF', '0',      'FFFFFF', '0',
        'A6CAF0', 'FFFFFF', '0',      'C0C0C0', 'FFFFFF', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      'C0C0C0', 'A6CAF0',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Arizona' => [
        '804000', 'FFFFFF', 'FFFFFF', '0',      'FFFFFF', '0',
        '808040', 'C0C0C0', 'FFFFFF', '4080FF', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      '808080', '808000',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Black Leather Jacket' => [
        '0',        'C0C0C0', 'FFFFFF', '0',      'C0C0C0', '0',
        '800040',   '808080', 'FFFFFF', '808080', '808080', '0',
        '10E0E0E0', 'C0C0C0', '808080', '0',      '808080', '0',
        'FFFFFF',   '0',      'FFFFFF'
    ],
    'Bordeaux' => [
        '400080', 'C0C0C0', 'FFFFFF', '0',      'FFFFFF', '0',
        '800080', 'C0C0C0', 'FFFFFF', 'FF0080', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      '808080', '800080',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Cinnamon' => [
        '404080', 'C0C0C0', 'FFFFFF', '0',  'FFFFFF', '0',
        '80',     'C0C0C0', 'FFFFFF', '80', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',  '808080', '80',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Designer' => [
        '7C7C3F', 'C0C0C0', 'FFFFFF', '0',      'FFFFFF', '0',
        '808000', 'C0C0C0', 'FFFFFF', 'C0C0C0', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      'C0C0C0', '808000',
        '0',      '0',      'FFFFFF'
    ],
    'Emerald City' => [
        '404000', 'C0C0C0', 'FFFFFF', '0',      'C0C0C0', '0',
        '408000', '808040', 'FFFFFF', '408000', '808040', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      '808080', '8000',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Fluorescent' => [
        '0',      'FFFFFF', 'FFFFFF', '0',    'FF00',   '0',
        'FF00FF', 'C0C0C0', '0',      'FF80', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',    '808080', '0',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Hotdog Stand' => [
        'FFFF',   'FFFF',   'FF',     'FFFFFF', 'FFFFFF', '0',
        '0',      'FF',     'FFFFFF', 'FF',     'FF',     '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      '808080', '0',
        'FFFFFF', 'FFFFFF', 'FFFFFF'
    ],
    'LCD Default Screen Settings' => [
        '808080', 'C0C0C0', 'C0C0C0', '0',      'C0C0C0', '0',
        '800000', 'C0C0C0', 'FFFFFF', '800000', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '7F8080', '0',      '808080', '800000',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'LCD Reversed - Dark' => [
        '0',      '80',     '80',     'FFFFFF', '8080',   '0',
        '8080',   '800000', '0',      '8080',   '800000', '0',
        '8080',   'C0C0C0', '7F8080', '0',      'C0C0C0', '800000',
        'FFFFFF', '828282', 'FFFFFF'
    ],
    'LCD Reversed - Light' => [
        '800000', 'FFFFFF', 'FFFFFF', '0',      'FFFFFF', '0',
        '808040', 'FFFFFF', '0',      'C0C0C0', 'C0C0C0', '800000',
        'C0C0C0', 'C0C0C0', '7F8080', '0',      '808040', '800000',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Mahogany' => [
        '404040', 'C0C0C0', 'FFFFFF', '0',      'FFFFFF', '0',
        '40',     'C0C0C0', 'FFFFFF', 'C0C0C0', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      'C0C0C0', '80',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Monochrome' => [
        'C0C0C0', 'FFFFFF', 'FFFFFF', '0',      'FFFFFF', '0',
        '0',      'C0C0C0', 'FFFFFF', 'C0C0C0', 'C0C0C0', '0',
        '808080', 'C0C0C0', '808080', '0',      '808080', '0',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Ocean' => [
        '808000', '408000', 'FFFFFF', '0',      'FFFFFF', '0',
        '804000', 'C0C0C0', 'FFFFFF', 'C0C0C0', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      '0',      '808000',
        '0',      '0',      'FFFFFF'
    ],
    'Pastel' => [
        'C0FF82', '80FFFF', 'FFFFFF', '0',      'FFFFFF', '0',
        'FFFF80', 'FFFFFF', '0',      'C080FF', 'FFFFFF', '808080',
        'C0C0C0', 'C0C0C0', '808080', '0',      'C0C0C0', 'FFFF00',
        '0',      '0',      'FFFFFF'
    ],
    'Patchwork' => [
        '9544BB', 'C1FBFA', 'FFFFFF', '0',      'FFFFFF', '0',
        'FFFF80', 'FFFFFF', '0',      '64B14E', 'FFFFFF', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      '808080', 'FFFF00',
        '0',      '0',      'FFFFFF'
    ],
    'Plasma Power Saver' => [
        '0',      'FF0000', '0',      'FFFFFF', 'FF00FF', '0',
        '800000', 'C0C0C0', '0',      '80',     'FFFFFF', 'C0C0C0',
        'FF0000', 'C0C0C0', '808080', '0',      'C0C0C0', 'FFFFFF',
        '0',      '0',      'FFFFFF'
    ],
    'Rugby' => [
        'C0C0C0', '80FFFF', 'FFFFFF', '0',  'FFFFFF', '0',
        '800000', 'FFFFFF', 'FFFFFF', '80', 'FFFFFF', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',  '808080', '800000',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'The Blues' => [
        '804000', 'C0C0C0', 'FFFFFF', '0',      'FFFFFF', '0',
        '800000', 'C0C0C0', 'FFFFFF', 'C0C0C0', 'C0C0C0', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      'C0C0C0', '800000',
        'FFFFFF', '0',      'FFFFFF'
    ],
    'Tweed' => [
        '6A619E',   'C0C0C0', 'FFFFFF', '0',      'FFFFFF', '0',
        '408080',   'C0C0C0', 'FFFFFF', '404080', 'C0C0C0', '0',
        '10E0E0E0', 'C0C0C0', '808080', '0',      'C0C0C0', '8080',
        '0',        '0',      'FFFFFF'
    ],
    'Valentine' => [
        'C080FF', 'FFFFFF', 'FFFFFF', '0',      'FFFFFF', '0',
        '8000FF', '400080', 'FFFFFF', 'C080FF', 'C080FF', '0',
        'C0C0C0', 'C0C0C0', '808080', '0',      '808080', 'FF00FF',
        '0',      'FFFFFF', 'FFFFFF'
    ],
    'Wingtips' => [
        '408080', 'C0C0C0', 'FFFFFF', '0',    'FFFFFF', '0',
        '808080', 'FFFFFF', 'FFFFFF', '4080', 'FFFFFF', '0',
        '808080', 'C0C0C0', '808080', '0',    'C0C0C0', '808080',
        'FFFFFF', '0',      'FFFFFF'
    ],
);

1;
