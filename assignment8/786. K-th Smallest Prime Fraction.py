import heapq


class Solution:
    def kthSmallestPrimeFraction(self, A, k):
        """
        :type A: List[int]
        :type K: int
        :rtype: List[int]
        """
        ls = []
        heapq.heapify(ls)

        for i in range(len(A)-1):
            print(A[i], A[len(A)-1])
            heapq.heappush(ls, [A[i]/A[len(A)-1], i, len(A)-1])

        while k != 1:
            k -= 1
            _, i, j = heapq.heappop(ls)
            print(i, j)
            if i + 1 != j:
                heapq.heappush(ls, [A[i]/A[j-1], i, j-1])
        _, i, j = heapq.heappop(ls)
        return A[i], A[j]


a = Solution()
res = a.kthSmallestPrimeFraction(A=[1, 2, 3, 5], k=3)
print(res)
