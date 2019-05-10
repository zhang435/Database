import os
import re

for root, dirs, files in os.walk("."):
    for file in files:
        if ".txt" in file:
            with open(file) as f:
                contents = f.readlines()

                formatter = "(" + ",".join(
                    ["{"+str(i)+"}" for i in range(len(re.split('\t|, ', contents[0])))]) + ")"
                ans = "INSERT INTO " + \
                    file.replace(".txt", "").title()+"(\n"+"VALUES\n"
                foo = (lambda content: [i if i.isdigit() else "'" + i.strip() +
                                        "'" for i in re.split('\t|, ', content.replace("\n", ""))])
                ans += ",\n".join([formatter.format(*foo(content))
                                   for content in contents])
                ans += ");"
                print(ans)
