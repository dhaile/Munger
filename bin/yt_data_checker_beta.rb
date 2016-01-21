#!/usr/bin/env ruby
require 'csv'
# require_relative '/.../test/'
class Datachecker

  def initialize()
    @mismatch = Hash.new(0)
    @Csv_file_one = Struct.new(:account_email, :youtube_channel, :subscriber_count)
    @Csv_file_two = Struct.new(:account_email, :youtube_channel, :subscriber_count)
  end


  def compare
    first, second, third = ARGV
    File.open(first) do |input_file|
      File.open(second) do |input_file2|
        CSV.foreach(input_file, headers: true, converters: :numeric, header_converters: :symbol) do |row1|
          filterchannel(row1)
          filter_subscriber_count(row1)
          CSV.foreach(input_file2, headers: true, converters: :numeric, header_converters: :symbol) do |row2|
            filterchannel(row2)
            filter_subscriber_count(row2)
            csv_file_one_new, csv_file_two_new = method_name(row1, row2)
            pick_mismatch = pick_mismatch(csv_file_one_new, csv_file_two_new)
            if pick_mismatch
              puts csv_file_two_new.account_email
              @mismatch[csv_file_two_new.account_email]=csv_file_two_new

              break
            end
          end
        end
      end
      yield @mismatch
    end
  end

  def method_name(row1, row2)
    csv_file_one_new = @Csv_file_one.new(row1[:account_email], row1[:youtube_channel], row1[:subscriber_count])
    csv_file_two_new = @Csv_file_two.new(row2[:account_email], row2[:youtube_channel], row2[:subscriber_count])
    return csv_file_one_new, csv_file_two_new
  end

  def pick_mismatch(csv_file_one_new, csv_file_two_new)
    true_classor_false_class = csv_file_two_new.account_email == csv_file_one_new.account_email
    classor_false_class = csv_file_two_new.youtube_channel != csv_file_one_new.youtube_channel
    false_class = csv_file_two_new.subscriber_count != csv_file_one_new.subscriber_count
    true_classor_false_class &&((classor_false_class) || (false_class))
  end

  def filterchannel(row1)
    row_youtube_channel_include = row1[:youtube_channel].include?('youtube')
    if row_youtube_channel_include
      channel_filter1(row1)
    else
      channel_filter2(row1)
    end
  end

  def filter_subscriber_count(row2)
    if row2[:subscriber_count].is_a? String
      if row2[:subscriber_count].include?(',')
        row2[:subscriber_count] = row2[:subscriber_count].split(',').join().to_i
      else
        row2[:subscriber_count]=row2[:subscriber_count].to_i
      end
    end

  end

  def channel_filter2(row1)
    channel = row1[:youtube_channel]
    strip_UC(channel, row1)
  end

  def channel_filter1(row1)
    channel=row1[:youtube_channel].split(/\/channel\//)[1]
    strip_UC(channel, row1)
  end

  def strip_UC(channel, row1)
    if channel =~ /^UC/
      row1[:youtube_channel] = channel.split(/UC/)[1]
    else
      row1[:youtube_channel] = channel
    end
  end

  def option_filter(factor)
    return Proc.new { |n| factor }
  end
end
# End of Class Datachecker

datachecker=Datachecker.new
hashy=datachecker.compare { |yielder| yielder }
puts hashy

class Hash
  def find
    each do |value|
      return value.class if yield(value)
    end
    nil
  end
end
