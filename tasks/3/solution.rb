class CommandParser
  def initialize(command)
    @arguments = {}
    @options = []
    @parameter_options = []
    @command = command
  end

  def argument(argument_name, &block)
    @arguments[argument_name] = block
  end

  def option(short_name, long_name, description, &block)
    @options.push([short_name, long_name, description, block])
  end

  def option_with_parameter(short, long, description, parameter_name, &block)
    @parameter_options.push([short, long, description, block, parameter_name])
  end

  def parse(command_runner, argv)
    options = argv.select { |item| item.start_with?('-') }
    arguments = argv.reject { |item| options.include?(item) }
    parse_arguments(command_runner, arguments)
    parse_options(command_runner, options)
    parse_options_with_parameter(command_runner, options)
  end

  def parse_arguments(command_runner, args)
    options = args.select { |item| item.start_with?('-') }
    arguments = args.reject { |item| options.include?(item) }
    @arguments.each_with_index do |(_, block), index|
      block.call(command_runner, arguments[index])
    end
  end

  def parse_options(command_runner, opts)
    opts.each_with_index do |item|
      opt = @options.find { |s| (item == '-' + s[0]) || (item == '--' + s[1] ) }
      opt[3].call command_runner, true if opt
    end
  end

  def parse_options_with_parameter(command_runner, opts)
    opts.each_with_index do |item|
      opt = @parameter_options.find do |c|
        item.start_with?('-' + c[0]) || item.start_with?('--' + c[1])
      end
      if opt
        parameter = item.split('=')[1] || item.sub('-' + opt[0], '')
        opt[3].call command_runner, parameter
      end
    end
  end

  def help
    info = "Usage: #{@command}"
    @arguments.each { |key, _| info << " [#{key}]" }
    @options.each do |i|
      info = info + "\n    -" + i[0] + ", --" + i[1] + " " + i[2]
    end
    @parameter_options.each do |i|
      info = info + "\n    -" + i[0] + ", --" + i[1] + "=" + i[4] + " " + i[2]
    end
    info
  end
end
