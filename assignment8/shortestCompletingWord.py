import collections


class Solution:
    # def shortestCompletingWord(self, licensePlate, words):
    #     """
    #     :type licensePlate: str
    #     :type words: List[str]
    #     :rtype: str
    #     """
    #     res = ""
    #     dic = collections.Counter(
    #         [i.lower() for i in licensePlate if i.lower() in "qwertyuioplkjhgfdsazxcvbnm"])

    #     for word in sorted(words, key=lambda x: len(x)):
    #         tmp = collections.Counter(
    #             [i.lower() for i in word if i.lower() in "qwertyuioplkjhgfdsazxcvbnm"])
    #         res = True
    #         for k, v in dict(dic).items():
    #             if k not in tmp or dic[k] > tmp[k]:
    #                 res = False
    #                 break

    #         if res:
    #             return word
    def shortestCompletingWord(self, licensePlate, words):
        prs = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43,
               47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103]
        alphs = "qwertyuioplkjhgfdsazxcvbnm"
        self.pr_chars = dict(list(zip(alphs, prs)))
        print(self.pr_chars)
        num = self.prod_all(licensePlate)
        length = float("inf")
        res = ""

        for word in words:
            if self.prod_all(word) % num == 0 and len(word) < length:
                length, res = len(word), word
        return res

    def prod_all(self, word):
        res = 1
        for w in word:
            if w.isalpha():
                res *= self.pr_chars[w.lower()]
        return res


a = Solution()
res = a.shortestCompletingWord(licensePlate="1s3 PSt", words=[
    "step",
    "steps",
    "stripe", "stepple"
])
print(res)
