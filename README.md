# One-level-Cache-memory-system-integrated-with-RISC-V-Single-Cycle

In this project, we will work on implementing a simple caching system for the RISC-V processor. For simplicity, we will integrate the caching system with the single-cycle implementation. Additionally, we assume the following:

•	Only data memory will be cached. The instruction memory will not be affected.

•	We will have only one level of caching.

•	The main memory module is assumed to have a capacity of 4 Kbytes (word addressable using 10 bits or byte addressable using 12 bits)

•	Main memory access (for read or write) takes 4 clock cycles

•	The data cache geometry is (512, 16, 1). This means that the total cache capacity is 512 bytes, that each cache block is 16 bytes (implying that the cache has 32 blocks in total), and that the cache uses direct mapping.

•	The cache uses write-through and write-around policies for write hit and write miss handling and no write buffers exist. This implies that all SW instructions need to stall the processor.

•	LW instructions will only stall the processor in case of a miss.

![image](https://github.com/bassantatef/One-level-Cache-memory-system-integrated-with-RISC-V-Single-Cycle/assets/82764830/e26cd1a0-1d37-4894-be43-4412535a28c5)

![image](https://github.com/bassantatef/One-level-Cache-memory-system-integrated-with-RISC-V-Single-Cycle/assets/82764830/aace25ba-7905-40d9-a516-7e1f32045e91)
