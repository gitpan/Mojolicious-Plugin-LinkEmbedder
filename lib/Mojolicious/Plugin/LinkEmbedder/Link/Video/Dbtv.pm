package Mojolicious::Plugin::LinkEmbedder::Link::Video::Dbtv;

=head1 NAME

Mojolicious::Plugin::LinkEmbedder::Link::Video::Dbtv - dbtv.no video

=head1 DESCRIPTION

This class inherit from L<Mojolicious::Plugin::LinkEmbedder::Link::Video>.

=cut

use Mojo::Base 'Mojolicious::Plugin::LinkEmbedder::Link::Video';

=head1 ATTRIBUTES

=head2 media_id

Returns the the digit from the url L</url>.

=cut

has media_id => sub {
  my $self = shift;
  my $url = $self->url;
  
  $url->query->param('vid') || $url->path->[-1];
};

=head1 METHODS

=head2 pretty_url

Returns a pretty version of the L</url>.

=cut

sub pretty_url {
  my $self = shift;
  my $media_id = $self->media_id or return $self->SUPER::to_embed;
  my $url = $self->url->clone;

  $url->fragment(undef);
  $url->query(vid => $media_id);
  $url;
}

=head2 to_embed

Returns the HTML code for an iframe embedding this movie.

=cut

sub to_embed {
  my $self = shift;
  my $src = Mojo::URL->new('beta.dbtv.no/player');
  my %args = @_;

  $args{height} ||= 551;
  $args{width} ||= 980;

  push @{ $src->path }, $self->media_id;
  $src->query({ autoplay => $args{autoplay} ? 'true' : 'false' });

  qq(<iframe src="$src" frameborder="0" width="$args{width}" height="$args{height}" scrolling="no" marginheight="0" marginwidth="0"></iframe>);
}

=head1 AUTHOR

Marcus Ramberg

=cut

1;
