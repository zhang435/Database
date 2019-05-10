x = """      1|      2
      2|      3
      3|      1
      0|      1
      3|      4
      4|      5
      5|      6
      """

for line in x.split("\n"):
    print("(", line.replace("|", ",").replace(
        "{", "\'{").replace("}", "}\'"), "),")

print(x)
