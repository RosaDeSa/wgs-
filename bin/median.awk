#!/usr/bin/env awk -f

{
    sum += $1
    nums[NR] = $1  
}
END {
    if (NR == 0) exit  


    median = (NR % 2 == 0) ? ( nums[NR / 2] + nums[(NR / 2) + 1] ) / 2  : nums[int(NR / 2) + 1]

    mean = sum/NR

    printf \
        "min = %s, max = %s, median = %s, mean = %s\n",\
        nums[1],\
        nums[NR],\
        median,\
        mean
}