require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  num.to_i.to_s == num || num.to_f.to_s == num
end

def operation_to_message(op)

  operation = case op
                when '1'
                  'adding'
                when '2'
                  'subtracting'
                when '3'
                  'multiplying'
                when '4'
                  'dividing'
              end

  "We are #{operation} the two numbers."
end

def messages(message, lang='en')
  MESSAGES[lang][message]
end

prompt(messages('welcome', 'en'))

name = ''
loop do
  name = Kernel.gets().chomp()

  if name.empty?()
    prompt(messages('valid_name', 'en'))
  else
    break
  end
end

prompt(messages('hi', 'en') + " #{name}!")

loop do # main loop
  number1 = ''
  loop do
    prompt(messages('first_number', 'en'))
    number1 = Kernel.gets().chomp()

    if valid_number?(number1)
      break
    else
      prompt(messages('invalid_number', 'en'))
    end
  end

  number2 = ''
  loop do
    prompt(messages('second_number', 'en'))
    number2 = Kernel.gets().chomp()

    if valid_number?(number2)
      break
    else
      prompt(messages('invalid_number', 'en'))
    end
  end

  operator_prompt = <<-MSG
    What operator would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG

  prompt(operator_prompt)

  operator = ''
  loop do
    operator = Kernel.gets().chomp()

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(messages('operator_error', 'en'))
    end
  end

  prompt(operation_to_message(operator))

  result = case operator
           when '1'
             number1.to_i() + number2.to_i()
           when '2'
             number1.to_i() - number2.to_i()
           when '3'
             number1.to_i() * number2.to_i()
           when '4'
             number1.to_f() / number2.to_f()
  end

  prompt(messages('result', 'en') + " #{result}")

  prompt(messages('calculate_again', 'en'))
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt(messages('thank_you', 'en'))
