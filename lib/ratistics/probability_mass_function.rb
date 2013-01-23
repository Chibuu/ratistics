module Ratistics

  # Various probability_mass_function computation functions.
  module ProbabilityMassFunction
    extend self

    # Calculates the statistical frequency.
    #
    # When a block is given the block will be applied to every
    # element in the data set. Using a block in this way allows
    # probability to be computed against a specific field in a
    # data set of hashes or objects.
    #
    # For a block {|item| ... }
    # @yield iterates over each element in the data set
    # @yieldparam item each element in the data set
    #
    # @param [Enumerable] data the data set to compute the frequency of
    # @param [Block] block optional block for per-item processing
    #
    # @return [Hash, nil] the statistical frequency of the given data set
    #   or nil if the data set is empty
    def frequency(data, &block)
      return nil if data.nil? || data.empty?

      freq = data.reduce({}) do |memo, datum|
        datum = yield(datum) if block_given?
        memo[datum] = memo[datum].to_i + 1
        memo
      end

      return freq
    end

    # Calculates the statistical probability.
    #
    # When a block is given the block will be applied to every
    # element in the data set. Using a block in this way allows
    # probability to be computed against a specific field in a
    # data set of hashes or objects.
    #
    # For a block {|item| ... }
    # @yield iterates over each element in the data set
    # @yieldparam item each element in the data set
    #
    # @param [Enumerable] data the data set to compute the probability of
    # @param [Block] block optional block for per-item processing
    #
    # @return [Hash, nil] the statistical probability of the given data set
    #   or nil if the data set is empty
    def probability(data, &block)
      return nil if data.nil? || data.empty?

      freq = frequency(data, &block)
      count = data.count

      prob = freq.reduce({}) do |memo, datum|
        memo[datum[0]] = datum[1].to_f / count.to_f
        memo
      end

      return prob
    end

    alias :pmf :probability

    # Calculates the statistical mean of a probability distribution.
    #
    # When a block is given the block will be applied to every
    # element in the data set. Using a block in this way allows
    # probability to be computed against a specific field in a
    # data set of hashes or objects.
    #
    # For a block {|item| ... }
    # @yield iterates over each element in the data set
    # @yieldparam item each element in the data set
    #
    # @param [Enumerable] data the data set to compute the mean of
    # @param [Block] block optional block for per-item processing
    #
    # @return [Float, 0] the statistical mean of the given data set
    #   or zero if the data set is empty
    def probability_mean(data, &block)
      return 0 if data.nil? || data.empty?

      pmf = probability(data, &block)
      return pmf.reduce(0.0){|n, item| n + (item[0] * item[1]) }
    end

    alias :pmf_mean :probability_mean

    # Calculates the statistical variance of a probability distribution.
    #
    # When a block is given the block will be applied to every
    # element in the data set. Using a block in this way allows
    # probability to be computed against a specific field in a
    # data set of hashes or objects.
    #
    # For a block {|item| ... }
    # @yield iterates over each element in the data set
    # @yieldparam item each element in the data set
    #
    # @param [Enumerable] data the data set to compute the variance of
    # @param [Block] block optional block for per-item processing
    #
    # @return [Float, 0] the statistical variance of the given data set
    #   or zero if the data set is empty
    def probability_variance(data, &block)
      return 0 if data.nil? || data.empty?

      pmf = probability(data, &block)
      mean = pmf.reduce(0.0){|n, item| n + (item[0] * item[1]) }

      return pmf.reduce(0.0){|n, item| n + (item[1] * ((item[0] - mean) ** 2)) }
    end

    alias :pmf_variance :probability_variance
  end
end
