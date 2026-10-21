=== "default"

    ```text
      addr          integral       2     'h1             
      length        integral       6     'd20            
      parity_type   parity_type_e  32    PARITY_TYPE_GOOD
      addr          integral       2     'h1             
      length        integral       6     'd9             
      parity_type   parity_type_e  32    PARITY_TYPE_GOOD
      addr          integral       2     'h0            
      length        integral       6     'd6            
      parity_type   parity_type_e  32    PARITY_TYPE_BAD
      addr          integral       2     'h1            
      length        integral       6     'd11           
      parity_type   parity_type_e  32    PARITY_TYPE_BAD
      length        integral       6     53              
    @0 reporter [TOP] copy  compare -> 1
    @0 reporter [TOP] clone compare -> 1
    @0 reporter [MISCMP] Miscompare for pkt.payload[0]: lhs = 'hbe : rhs = 'h41
    @0 reporter [MISCMP] 1 Miscompare(s) for object pkt@62 vs. clone_pkt@211
    @0 reporter [TOP] modified clone compare -> 0 (miscompare is reported above)
      length        integral       6     53              
    ... (4 more lines of the kinds above)
    ```
