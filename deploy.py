import urllib2,mimetools,json
filename='node-info.war'
server='http://localhost:9990'

BOUNDARY = mimetools.choose_boundary()
req = []
req.append('--' + BOUNDARY)
req.append('Content-Disposition: form-data; name="%s"; filename="%s"' % (filename, filename))
req.append('Content-Type: application/octet-stream')
req.append('')
req.append(open(filename,'r').read())
req.append('--' + BOUNDARY + '--')
req.append('')
content_type = 'multipart/form-data; boundary=%s' % BOUNDARY
hash = json.loads(urllib2.urlopen(urllib2.Request(server+'/management/add-content',data='\r\n'.join(req),headers={'content-type':content_type})).read())['result']['BYTES_VALUE']
print 'The uploaded hash is %s' % hash
body = json.dumps({'operation':'add','address':[{'deployment':filename}],'enabled':'true','content':[{'hash' : {'BYTES_VALUE':hash}}]})
print 'Enable deployment: %s' % json.loads(urllib2.urlopen(urllib2.Request(server+'/management',body)).read())['outcome']


