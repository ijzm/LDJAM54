import os
from PIL import Image
  
filelist = [file for file in os.listdir('.') if file.endswith('.png')]

for file in filelist:
	img = Image.open(file)
	rgba = img.convert("RGBA")
	datas = rgba.getdata()
	
	newData = []
	for item in datas:
		if item[0] == 255 and item[1] == 0 and item[2] == 255:  # finding black colour by its RGB value
			# storing a transparent value when we find a black colour
			newData.append((255, 255, 255, 0))
		else:
			newData.append(item)  # other colours remain unchanged
	
	rgba.putdata(newData)
	rgba.save(file, "PNG")