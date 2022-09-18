
def getMinDeletions(s):
    def findSubstrings(s1):
        res = []
        max_substr_len = len(s1)
        substr_len = 0

        while substr_len < max_substr_len:
            substr_len += 1

            for starting_point in range(0,substr_len):
                res.append(s1[starting_point:substr_len])

        return res

    my_string = s
    min_deletions = 0
    substrings = findSubstrings(s)
    loop_flag = True
    loop_count = 0

    while loop_flag == True:
        loop_count += 1
        loop_flag = False
        items_to_delete = []

        for item in substrings:
            if substrings.count(item) > 1 and len(item) == loop_count:
                loop_flag = True

                if item not in items_to_delete:
                    for i in range(substrings.count(item) - 1):
                        items_to_delete.append(item)

        if loop_flag == True:

            for item in items_to_delete:
                my_string = my_string.replace(item, '', 1)
                min_deletions += 1

            substrings = findSubstrings(my_string)

    return min_deletions

print(getMinDeletions("bbeadcebfp"))
