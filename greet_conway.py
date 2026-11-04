import sys, os

print("HELLO!!!!")
while True:
    if input() == "q":
        break


os.system(" ".join(sys.argv[1:]))
