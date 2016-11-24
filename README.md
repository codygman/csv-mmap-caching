# csv-mmap-caching

An example of using cassava to read a file from csv into a vector, convert that vector into a storable vector, mmap it to a file, then read that mmap back into memory and do some processing with it. The advantage being the read of the data is almost instantaneous.
