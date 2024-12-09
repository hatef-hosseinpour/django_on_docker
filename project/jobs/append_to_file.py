
import time
timestr = time.strftime("%Y%m%d-%H%M%S")
with open("test.txt", "a") as myfile:
    myfile.write(f"appended text {timestr} \n")
