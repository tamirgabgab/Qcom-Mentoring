//------------------------------------------------------------------------------
// rand_util_pkg.sv -- random values for the whole environment
//
// Every random value that is not a field of a randomized object (a sequence
// item, a sequence) comes from here instead of $urandom / $urandom_range:
//
//   import rand_util_pkg::*;
//   idx     = rnd::get_index(8, "yapp_packet.bad_parity_bit");   // 0..7
//   delay   = rnd::get_int(1, 20, "driver.delay");
//   payload = rnd::get_bytes(length, "yapp_packet.payload");     // bit [7:0] []
//   q       = rnd::get_byte_queue(4, "test.header");             // bit [7:0] [$]
//   fixed   = rnd_array #(8)::get_bytes("test.key");             // bit [7:0] [8]
//
// Every function draws with std::randomize(), so the values follow the
// simulation seed. The last argument names the value: when a draw fails,
// the uvm_fatal says which one.
//
// Objects keep their own randomize() (req.randomize() with {...}): their
// constraints and factory overrides belong to the class.
//
// Arrays are sized first and randomized afterwards: a size constraint inside
// std::randomize() with {...} is not honoured by every simulator (Verilator
// 5.052 returns an empty queue).
//------------------------------------------------------------------------------
package rand_util_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef bit [7:0] rnd_bytes_t[];       // dynamic array of bytes
  typedef bit [7:0] rnd_byte_q_t[$];     // queue of bytes

  // Static functions only: call them as rnd::get_int(...), no object needed
  virtual class rnd;

    // One random bit
    extern static function bit get_bit(string name = "");

    // A signed / unsigned integer in [min:max] (both ends included)
    extern static function int get_int(int min, int max, string name = "");
    extern static function int unsigned get_uint(int unsigned min, int unsigned max, string name = "");

    // A random byte (0..255)
    extern static function bit [7:0] get_byte(string name = "");

    // A vector of `width` random bits (1..64); the upper bits are 0
    extern static function bit [63:0] get_bits(int unsigned width, string name = "");

    // An index into a collection of `size` elements: 0..size-1
    extern static function int unsigned get_index(int unsigned size, string name = "");

    // `size` random bytes, as a dynamic array or as a queue
    extern static function rnd_bytes_t get_bytes(int unsigned size, string name = "");
    extern static function rnd_byte_q_t get_byte_queue(int unsigned size, string name = "");

    // The name used in the messages ("<unnamed>" when none was given)
    extern static function string label(string name);

  endclass : rnd

  //----------------------------------------------------------------------------
  // rnd_array #(N) -- N random bytes in a fixed-size array
  //   bit [7:0] key[8];
  //   key = rnd_array #(8)::get_bytes("test.key");
  // (a dynamic array cannot be assigned to a fixed-size one in every simulator,
  // so the size is a parameter)
  //----------------------------------------------------------------------------
  virtual class rnd_array #(int N = 8);

    typedef bit [7:0] bytes_t[N];

    static function bytes_t get_bytes(string name = "");
      bytes_t a;
      if (!std::randomize(a)) begin
        `uvm_fatal("RND", $sformatf("%s: rnd_array #(%0d)::get_bytes() failed", rnd::label(name), N))
      end
      return a;
    endfunction : get_bytes

  endclass : rnd_array

  //----------------------------------------------------------------------------
  // rnd -- method implementations
  //----------------------------------------------------------------------------

  function bit rnd::get_bit(string name = "");
    bit value;
    if (!std::randomize(value)) begin
      `uvm_fatal("RND", $sformatf("%s: get_bit() failed", label(name)))
    end
    return value;
  endfunction : get_bit

  //----------------------------------------------------------------------------
  function int rnd::get_int(int min, int max, string name = "");
    int value;
    if (min > max) begin
      `uvm_fatal("RND", $sformatf("%s: get_int(%0d, %0d): min is greater than max", label(name), min, max))
    end
    if (!std::randomize(value) with { value inside {[min:max]}; }) begin
      `uvm_fatal("RND", $sformatf("%s: get_int(%0d, %0d) failed", label(name), min, max))
    end
    return value;
  endfunction : get_int

  //----------------------------------------------------------------------------
  function int unsigned rnd::get_uint(int unsigned min, int unsigned max, string name = "");
    int unsigned value;
    if (min > max) begin
      `uvm_fatal("RND", $sformatf("%s: get_uint(%0d, %0d): min is greater than max", label(name), min, max))
    end
    if (!std::randomize(value) with { value inside {[min:max]}; }) begin
      `uvm_fatal("RND", $sformatf("%s: get_uint(%0d, %0d) failed", label(name), min, max))
    end
    return value;
  endfunction : get_uint

  //----------------------------------------------------------------------------
  function bit [7:0] rnd::get_byte(string name = "");
    bit [7:0] value;
    if (!std::randomize(value)) begin
      `uvm_fatal("RND", $sformatf("%s: get_byte() failed", label(name)))
    end
    return value;
  endfunction : get_byte

  //----------------------------------------------------------------------------
  function bit [63:0] rnd::get_bits(int unsigned width, string name = "");
    bit [63:0] value;
    if (width < 1 || width > 64) begin
      `uvm_fatal("RND", $sformatf("%s: get_bits(%0d): width must be 1..64", label(name), width))
    end
    if (!std::randomize(value)) begin
      `uvm_fatal("RND", $sformatf("%s: get_bits(%0d) failed", label(name), width))
    end
    // keep the low `width` bits (a shift by 64 gives 0, so width 64 keeps all)
    return value & ((64'h1 << width) - 64'h1);
  endfunction : get_bits

  //----------------------------------------------------------------------------
  function int unsigned rnd::get_index(int unsigned size, string name = "");
    if (size == 0) begin
      `uvm_fatal("RND", $sformatf("%s: get_index(0): the collection is empty", label(name)))
    end
    return get_uint(0, size - 1, name);
  endfunction : get_index

  //----------------------------------------------------------------------------
  function rnd_bytes_t rnd::get_bytes(int unsigned size, string name = "");
    rnd_bytes_t a;
    a = new[size];
    if (size > 0 && !std::randomize(a)) begin
      `uvm_fatal("RND", $sformatf("%s: get_bytes(%0d) failed", label(name), size))
    end
    return a;
  endfunction : get_bytes

  //----------------------------------------------------------------------------
  function rnd_byte_q_t rnd::get_byte_queue(int unsigned size, string name = "");
    rnd_byte_q_t q;
    q = get_bytes(size, name);
    return q;
  endfunction : get_byte_queue

  //----------------------------------------------------------------------------
  function string rnd::label(string name);
    return (name == "") ? "<unnamed>" : name;
  endfunction : label

endpackage : rand_util_pkg
