package Mojolicious::Plugin::ProRenderer;

{
  $Mojolicious::Plugin::HtpRenderer::VERSION = '0.40';
}

use strict;
use warnings;
use v5.10;

use base 'Mojolicious::Plugin';
use HTML::Template::Pro ();

__PACKAGE__->attr('pro');

# register plugin
sub register {
    my ($self, $app, $args) = @_;

    $args ||= {};

    # $args{template_options}{path} = [ './templates']
    $args->{template_options}{path} = $app->{renderer}{paths}
        unless exists $args->{template_options}{path};

    my $template = $self->build(%$args, app => $app);

    # Add "pro" handler
    $app->renderer->add_handler(pro => $template);

}

sub build {
    my $self = shift->SUPER::new(@_);
    $self->_init(@_);
    return sub { $self->_render(@_) }
}

sub _init {
    my $self = shift;
    my %args = @_;

    my $mojo = delete $args{mojo};

    # now we only remember options 
    $self->pro($args{template_options});

    return $self;
}

sub _render {
    my ($self, $renderer, $c, $output, $options) = @_;

    # Inline
    my $inline = $options->{inline};

    # Template
    my $template = $renderer->template_name($options);
    $template = 'inline' 
        if defined $inline;

    warn "render template: $template"
        if $self->pro->{debug};  

    unless ($template) {
        $$output = 'some error happen!';
        return 0;        
    }
      
    # try to get content
    my $content = eval {
       my $t = HTML::Template::Pro->new(
           filename            => $template,
           # die_on_bad_params   => 1,
           %{$self->pro // {} }
        );

        # filter mojo.* variables
        my %params = map { $_ => $c->stash->{$_} } 
            grep !/mojo/, keys %{$c->stash};

        $t->param({%params, c => $c});
        $t->output();
    };

    # write error message to STDERR if eval fails
    # and return with false
    if($@ and $self->pro->{debug}) {
        warn "ERROR: $@";
        return 0;
    }

    # return false if content empty
    unless ($content) {
        # write error message to output
        $$output = "error while processing template: $template";
        return 1;
    }
    
    # assign content to $output ref 
    $$output = $content;
    
    # and return with true (success)
    return 1;
}

1;  

=head1 NAME

Mojolicious::Plugin::ProRenderer - HTML::Tempate::Pro render plugin for Mojolicious

=head1 VERSION

Version 0.40

=head1 SYNOPSIS

Add the handler:

    # Mojolicious
  
    sub startup {
       ...

       $self->plugin('pro_renderer');
       ...
    }

    in controller:

    $self->render(
        message => 'test', 
        list    => [{id => 1}, { id=>2 }]
    );

=head1 FUNCTIONS

=head2 build

create handler for renderer

=head2 register

register plugin 'pro_renderer'

=cut