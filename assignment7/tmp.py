import json

s = '{"a" : 1}'

dic = json.loads(s)
dic["b"] = 1
print(dic)
