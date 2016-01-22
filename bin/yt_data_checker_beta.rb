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
          # puts 'before'
          #     p row1[1]
          filterchannel(row1)
          filter_subscriber_count(row1)
          # puts 'after'
          #   p row1[1]
          CSV.foreach(input_file2, headers: true, converters: :numeric, header_converters: :symbol) do |row2|
            #  puts 'before'
            # p  row2[1]
            filterchannel(row2)
            filter_subscriber_count(row2)
            # puts 'after'
            #  p row2[1]
            csv_file_one_new, csv_file_two_new = method_name(row1, row2)
            if third
              if third.to_s == 'subscriber_count'
                pick_mismatch = pick_mismatch_subscriber_count(csv_file_one_new, csv_file_two_new)
              elsif third.to_s == 'channel_ownership'
                pick_mismatch = pick_mismatch_channel(csv_file_one_new, csv_file_two_new)
              else
                puts 'option can be only  subscriber_count and channel_ownership'

              end
            else
              pick_mismatch = pick_mismatch(csv_file_one_new, csv_file_two_new)
            end
            if pick_mismatch
              puts csv_file_two_new.account_email
              @mismatch[csv_file_two_new.account_email]=csv_file_two_new
              break
            end
          end
        end
      end
      yield @mismatch, third # pass the concern param
    end

  end

  def method_name(row1, row2)
    csv_file_one_new = @Csv_file_one.new(row1[0], row1[1], row1[2])
    csv_file_two_new = @Csv_file_two.new(row2[0], row2[1], row2[2])
    return csv_file_one_new, csv_file_two_new
  end

  def pick_mismatch(csv_file_one_new, csv_file_two_new)
    is_email_same = csv_file_two_new.account_email == csv_file_one_new.account_email
    is_channel_diff = csv_file_two_new.youtube_channel != csv_file_one_new.youtube_channel
    is_subscriber_count_same = csv_file_two_new.subscriber_count != csv_file_one_new.subscriber_count
    is_email_same &&((is_channel_diff) || (is_subscriber_count_same))

  end

  def pick_mismatch_channel(csv_file_one_new, csv_file_two_new)
    is_email_same = csv_file_two_new.account_email == csv_file_one_new.account_email
    is_channel_diff = csv_file_two_new.youtube_channel != csv_file_one_new.youtube_channel
    is_email_same && is_channel_diff
  end

  def pick_mismatch_subscriber_count(csv_file_one_new, csv_file_two_new)
    is_email_same = csv_file_two_new.account_email == csv_file_one_new.account_email
    is_subscriber_count_same = csv_file_two_new.subscriber_count != csv_file_one_new.subscriber_count
    is_email_same && is_subscriber_count_same
  end

  def filterchannel(row1)
     row_youtube_channel_include = row1[1].include?('youtube')
    if row_youtube_channel_include
      channel_filter1(row1)
    else
      channel_filter2(row1)
    end
  end

  def filter_subscriber_count(row2)
    if row2[2].is_a? String
      if row2[2].include?(',')
        row2[2] = row2[2].split(',').join().to_i
      else
        row2[2]=row2[2].to_i
      end
    else
      row2[2]=row2[2].to_i
    end

  end

  def channel_filter2(row1)
    channel = row1[1]
    strip_UC(channel, row1)
  end

  def channel_filter1(row1)
    channel=row1[1].split(/\/channel\//)[1]
    strip_UC(channel, row1)
  end

  def strip_UC(channel, row1)
    channel =~ /\AUC/i
    if channel =~ /\AUC/i
      row1[1] = channel.split(/UC/i)[1]
    else
      row1[1] = channel
    end
  end
end
# End of Class Datachecker

datachecker=Datachecker.new
datachecker.compare { |yielder, d| [yielder, d] }

