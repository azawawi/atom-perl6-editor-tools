use v6;

=begin pod

=head1 NAME

MagicWand - ImageMagick's MagickWand API Bindings for Perl6

=head1 SYNOPSIS

=begin code

use v6;
use MagickWand;

# A new magic wand
my $wand = MagickWand.new;

# Read an image
$wand.read("examples/images/aero1.jpg");

# Lighten dark areas
$wand.auto-gamma;

# And then write a new image
$wand.write("output.png");

# And cleanup on exit
LEAVE {
  $wand.cleanup if $wand.defined;
}

=end code

=head1 DESCRIPTION

This provides a Perl 6 object-oriented NativeCall
L<NativeCall|http://doc.perl6.org/language/nativecall>-based API for ImageMagick's
L<MagickWand C API|http://www.imagemagick.org/script/magick-wand.php>.

=end pod
