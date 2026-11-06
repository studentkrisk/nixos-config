import sys, os
from time import time
from random import randint
from math import ceil

MONTH_LENGTHS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
MONTH_NAMES = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

while input(time()) != "q":
    continue

# a uniform distribution is unnecessary, and in fact (slightly) less useful than a slightly skewed one!
year = randint(1600, 2400) # inclusive!
leap_year = (year % 4 == 0) and (year % 100 != 0 or year % 400 == 0)
MONTH_LENGTHS[1] += int(leap_year)
month = randint(0, 11)
day = randint(1, MONTH_LENGTHS[month])

print(f"{MONTH_NAMES[month]} {day}, {year}")

# 1599 dec 31 was on a friday!
day_of_week = 5 + day + sum(MONTH_LENGTHS[:month]) + (year-1600)*365 + ceil((year-1600)/4) - ceil((year-1600)/100) + ceil((year-1600)/400)
day_of_week %= 7

amm_time = time()
num_wrong = 0
while True:
    inp = input("> ")
    if inp.isnumeric():
        if int(inp) == day_of_week:
            amm_time = time() - amm_time
            break
        num_wrong += 1
    if inp == "help":
        print("month offsets: 240 035 136 240")
        print("year offsets: 0 531 642")
        print("century offsets: 5320")
    if inp == "q":
        num_wrong = -1
        break

input(amm_time)

with open(sys.argv[1], "a") as f:
    f.write(f"{time()},{amm_time},{num_wrong}\n")
    f.close()

os.system(" ".join(sys.argv[2:]))
