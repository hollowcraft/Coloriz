import math

l = [0, 50, 150, 200, 250, 350, 400, 500, 550, 600]

for i in range(1, 10):
    a = math.floor(0.2 * i + 0.5)
    b = math.floor(0.2* i - 0.2)
    d = (i - 1 + math.floor(0.2 * i + 0.5) + math.floor(0.2* i - 0.2)) 
    print (i,":", l[i-1]/50, "/", d, "=", i-1, "+", 0.2 * i + 0.5, "+", 0.2* i - 0.2)
    
print("test:", math.floor(1.5))