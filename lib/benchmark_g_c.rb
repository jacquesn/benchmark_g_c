require "benchmark_g_c/version"

module BenchmarkGC
  @@total_objects_allocated = 0
  @@total_bchecks = 0

  def self.total_bchecks
    @@total_bchecks
  end

  def self.increment_bchecks
    @@total_bchecks += 1
  end

  def self.total_objects_allocated
    @@total_objects_allocated
  end

  def self.add_objects(objects)
    @@total_objects_allocated += objects
  end

  def bcheck(options)
    default_options = { name: '', times: 1, logger: true }
    options = default_options.merge(options)
    name = options[:name]
    times = options[:times]
    logger = options[:logger]
    # This should first check if gem is in Rails environment
    ActiveRecord::Base.logger = nil unless logger
    results = []
    return_value = nil
    times.times do
      time_before = Time.now
      stat_before = GC.stat
      return_value = yield
      time_after = Time.now
      stat_after = GC.stat
      results.push(
        time_elapsed: time_after - time_before,
        heap_free_slots_added: stat_after[:heap_free_slots] - stat_before[:heap_free_slots],
        objects_allocated: stat_after[:total_allocated_objects] - stat_before[:total_allocated_objects],
        objects_freed: stat_after[:total_freed_objects] - stat_before[:total_freed_objects]
      )
      print_benchmark(name, time_before, time_after, stat_before, stat_after)
    end
    averaged_results = average_results(results)
    BenchmarkGC::increment_bchecks
    BenchmarkGC::add_objects(averaged_results[:objects_allocated])
    print_averaged_results(averaged_results, times)
    return_value
  end

  def print_benchmark(name, time_before, time_after, stat_before, stat_after)
    print "-------------------------------------------------------------------\n"
    print "#{name}\n"
    print "Time Elapsed: #{time_after - time_before}\n\n"
    printf("%-25s %-14s %-14s %-14s\n", 'GC Stat', 'before', 'after', 'diff')
    print "-------------------------------------------------------------------\n"
    print_stats('heap_free_slots', stat_before[:heap_free_slots], stat_after[:heap_free_slots])
    print_stats('total_allocated_objects', stat_before[:total_allocated_objects], stat_after[:total_allocated_objects])
    print_stats('total_freed_objects', stat_before[:total_freed_objects], stat_after[:total_freed_objects])
    print "-------------------------------------------------------------------\n"
  end

  def print_stats(name, before, after)
    formatter = "%-25s %-14d %-14d %-14d\n"
    printf(formatter, name, before, after, after - before)
  end

  def average_results(results)
    summed_results = sum_results(results)
    summed_results.each do |key, value|
      summed_results[key] = value / results.length
    end
  end

  def sum_results(results)
    summed_results = results[0].clone
    results[1..-1].each do |result|
      summed_results.keys.each do |key|
        summed_results[key] += result[key]
      end
    end
    summed_results
  end

  def print_averaged_results(results, times_run)
    print "-------------------------------------------------------------------\n"
    print "Average Results after running #{times_run} times\n"
    print "-------------------------------------------------------------------\n"
    formatter = "%-25s %-14s\n"
    results.each do |key, value|
      printf(formatter, key, underscore_number(value))
    end
    print "Total bchecks run for server instance: #{underscore_number BenchmarkGC::total_bchecks}\n"
    print "Total Objects Allocated for server instance: #{underscore_number BenchmarkGC::total_objects_allocated}\n"
    print "-------------------------------------------------------------------\n"
  end

  def underscore_number(number)
    insert_underscores(number.round.to_s.reverse).reverse
  end

  def insert_underscores(string)
    (1..(string.length - 1) / 3).each do |n|
      string.insert(n * 3 + n - 1, '_') unless string[n * 3 + n - 1] == '-'
    end
    string
  end
end
