package Mojolicious::Plugin::LinkEmbedder::Link::Image::Imgur;

=head1 NAME

Mojolicious::Plugin::LinkEmbedder::Link::Image::Imgur - imgur.com image

=head1 DESCRIPTION

This class inherits from L<Mojolicious::Plugin::LinkEmbedder::Link::Image>.

=cut

use Mojo::Base 'Mojolicious::Plugin::LinkEmbedder::Link::Image';

use Mojo::URL;
use Mojo::IOLoop;

=head1 ATTRIBUTES

=head2 media_id

Extracts the media_id from the url directly

=cut

has media_id => sub { shift->url->path->[0] };

=head2 media_url

URL to the image itself, extracted from the retrieved page

=head2 media_title

The title of the image, extracted from the retrieved page

=cut

has [qw(media_url media_title)];

=head1 METHODS

=head2 learn

Gets the file imformation from the page meta information

=cut

sub learn {
  my ($self, $cb, @cb_args) = @_;
  my $ua    = $self->{ua};
  my $delay = Mojo::IOLoop->delay(
    sub {
      my $delay = shift;
      $ua->get($self->url, $delay->begin);
    },
    sub {
      my ($ua, $tx) = @_;
      my $dom = $tx->res->dom;
      $self->media_url(Mojo::URL->new(($dom->at('meta[property="og:image"]') || {})->{content}));
      $self->media_title(($dom->at('meta[property="og:title"]') || {})->{content});
      $cb->(@cb_args);
    },
  );
  $delay->wait unless $delay->ioloop->is_running;
}

=head2 to_embed

Returns an img tag.

=cut

sub to_embed {
  my $self = shift;
  my $url  = $self->media_url;
  my %args = @_;

  $args{alt} ||= $self->media_title;

  qq(<img src="$url" alt="$args{alt}">);
}

=head1 AUTHOR

Joel Berger - C<jberger@cpan.org>

=cut

1;
