# -*- coding: utf-8 -*-

import os
import re
import urllib

URL_REG = re.compile(r'(http://[^/\\]+)', re.I)
IMG_REG = re.compile(r'<img[^>]*?src=([\'"])([^\1]*?)\1', re.I)

def download(dir, url):

    global URL_REG, IMG_REG

    m = URL_REG.match(url)  #IMG_REG
    if not m:
        print '[Error]Invalid URL: ', url
        return
    host = m.group(1)

    if not os.path.isdir(dir):
        os.mkdir(dir)

    #获取html，提取图片url
    html = urllib.urlopen(url).read()
    imgs = [ item[1] for item in IMG_REG.findall(html) ]
    
    f = lambda path: path if path.startswith('http://') else \
        host + path if path.startswith('/') else url + '/' + path
    
    imgs = list(set(map(f, imgs)))
    print '[Info]Find %d images.' % len(imgs)

    #下载图片
    for idx, img in enumerate(imgs):
        name = img.split('/')[-1]
        path = os.path.join(dir, name)
        try:
            print '[Info]Download(%d): %s' % (idx+1, img)
            urllib.urlretrieve(img, path)
        except:
            print "[Error]Can't download(%d): %s" % (idx+1, img)

#运行从这里开始，第一个参数是保存路径，第二个参数是网址
savePath = '/Volumes/file/data'
questHTTP = 'http://wanimal1983.org/'
download(savePath, questHTTP)
