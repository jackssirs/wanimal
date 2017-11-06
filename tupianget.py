#coding=utf-8

import os
import sys
import re
import urllib

URL_REG = re.compile(r'(http://[^///]+)', re.I)
#IMG_REG = re.compile(r'<jpg[^>]*?src=([/'"])([^/1]*?)\1', re.I)
IMG_REG = re.compile(r''']*?src=([/'"])([^\1]*?)\1''', re.I) 

def download(dir, url):
	'''下载网页中的图片
	
	@dir 保存到本地的路径
	@url 网页url
	'''
	global URL_REG, IMG_REG
	
	m = URL_REG.match(url)
	if not m: 
		print '[Error]Invalid URL: ', url
		return
	host = m.group(1)
	
	if not os.path.isdir(dir):
		os.mkdir(dir)
	
	# 获取html,提取图片url
	html = urllib.urlopen(url).read()
	imgs = [item[1].lower() for item in IMG_REG.findall(html)]
	f = lambda path: path if path.startswith('http://') else /  
				host + path if path.startswith('/') else url + '/' + path 
	imgs = list(set(map(f, imgs)))
	print '[Info]Find %d images.' % len(imgs)
	
	# 下载图片
	for idx, img in enumerate(imgs):
		name = img.split('/')[-1]
		path = os.path.join(dir, name)
		try: 
			print '[Info]Download(%d): %s'% (idx + 1, img)
			urllib.urlretrieve(img, path)
		except: 
			print "[Error]Cant't download(%d): %s" % (idx + 1, img)
	
def main():
	if len(sys.argv) != 3:
		print 'Invalid argument count.'
		return
	dir, url = sys.argv[1:]
	download(dir, url)

if __name__ == '__main__':
	download('/Volumes/file/data', 'http://wanimal1983.tumblr.com')
	main()