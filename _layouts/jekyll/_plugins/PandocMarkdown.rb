class Jekyll::Converters::Markdown::Pandoc
  DEFAULT_OPTIONS = []
  DEFAULT_FORMAT = 'html5'
  def initialize(config)
    #require 'pandoc-ruby'
    Jekyll::External.require_with_graceful_fail "pandoc-ruby"
    @config = config
  rescue LoadError
    STDERR.puts 'You are missing a library required for Markdown. Please run:'
    STDERR.puts '  $ [sudo] gem install pandoc-ruby'
    raise FatalException.new("Missing dependency: pandoc-ruby")
  end
  def convert(content)
    options = config_option('options', DEFAULT_OPTIONS)
    format = config_option('format', DEFAULT_FORMAT)
    content = PandocRuby.new(content,
      *options).send("to_#{format}").force_encoding(Encoding::UTF_8)
    raise Jekyll::Errors::FatalException, "Conversion returned empty string" unless content.length > 0
    content
    #, {:F => "pandoc-crossref", :F => "pandoc-citeproc" }
    # The .force_encoding(Encoding::UTF_8) is a hack from
    # https://github.com/jekyll/jekyll/issues/2629
    #::PandocRuby.new(content).to_html.force_encoding(Encoding::UTF_8)
    # TODO: Make the converter take into consideration options
  end
  def config_option(key, default=nil)
    if @config['pandoc']
      @config.fetch('pandoc', {}).fetch(key, default)
    else
      default
    end
  end
end
