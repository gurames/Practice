def sum_negative_between_min_max_v2(arr):
    if not arr:
        return 0
    
    idx_max = arr.index(max(arr))
    idx_min = arr.index(min(arr))
    
    start = min(idx_max, idx_min)
    end = max(idx_max, idx_min)
    
    return sum(x for x in arr[start+1:end] if x < 0)