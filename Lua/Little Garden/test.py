import math

plant = {}
for i in range(1, 26):
    plant[i] = 0
print('loaded')

def extend(list):
    lenth = int(math.sqrt(len(list)))
    for i in range(len(list)+1, (lenth+1)**2 +1):
        list[i] = 0
        
    len = math.sqrt(len(list))
    for i in range(len-1):
    	for j in range(2,len-1):
    		list[j*len-i] = list[j*len-i-1]

print(len(plant))
extend(plant)
print(len(plant))