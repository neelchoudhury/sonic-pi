require_relative 'bench_helper'

iter = ITER

puts "Benchmark Buffer#put_array_of_float performance, #{iter}x"

5.times {
  ptr = FFI::Buffer.new(:float, 8, false)
  puts Benchmark.measure {
    iter.times {
      ptr.put_array_of_float(0, [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8 ])
    }
  }
}


puts "Benchmark Buffer.new(:float, 8, false)).put_array_of_float performance, #{iter}x"
5.times {
  puts Benchmark.measure {
    iter.times {
      ptr = FFI::Buffer.new(:float, 8, false)
      ptr.put_array_of_float(0, [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8 ])
    }
  }
}

module LibTest
  extend FFI::Library
  ffi_lib LIBTEST_PATH

  attach_function :bench, :bench_P_v, [ :buffer_in ], :void
end

puts "Benchmark Buffer alloc+fill+call performance, #{iter}x"
5.times {
  puts Benchmark.measure {
    iter.times {
      ptr = FFI::Buffer.new(:float, 8, false)
      ptr.put_array_of_float(0, [ 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8 ])
      LibTest.bench(ptr)
    }
  }
}
