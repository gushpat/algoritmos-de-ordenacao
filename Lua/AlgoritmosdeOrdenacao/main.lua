math.randomseed(os.time())

function swap(v, i, j)
    v[i], v[j] = v[j], v[i]
end

function bubbleSort(v)
    for i = 1, #v - 1 do
        for j = 1, #v - i do
            if v[j] > v[j + 1] then
                swap(v, j, j + 1)
            end
        end
    end
end

function selectionSort(v)
    for i = 1, #v - 1 do
        local min = i
        for j = i + 1, #v do
            if v[j] < v[min] then min = j end
        end
        swap(v, i, min)
    end
end

function insertionSort(v)
    for i = 2, #v do
        local key = v[i]
        local j = i - 1
        while j >= 1 and v[j] > key do
            v[j + 1] = v[j]
            j = j - 1
        end
        v[j + 1] = key
    end
end

function mergeSort(v, left, right)
    if left < right then
        local mid = math.floor((left + right) / 2)
        mergeSort(v, left, mid)
        mergeSort(v, mid + 1, right)
        merge(v, left, mid, right)
    end
end

function merge(v, left, mid, right)
    local L, R = {}, {}
    for i = left, mid do L[#L + 1] = v[i] end
    for i = mid + 1, right do R[#R + 1] = v[i] end
    local i, j, k = 1, 1, left
    while i <= #L and j <= #R do
        if L[i] <= R[j] then v[k] = L[i]; i = i + 1
        else v[k] = R[j]; j = j + 1 end
        k = k + 1
    end
    while i <= #L do v[k] = L[i]; i = i + 1; k = k + 1 end
    while j <= #R do v[k] = R[j]; j = j + 1; k = k + 1 end
end

function quickSort(v, low, high)
    if low < high then
        local pi = partition(v, low, high)
        quickSort(v, low, pi - 1)
        quickSort(v, pi + 1, high)
    end
end

function partition(v, low, high)
    local pivot = v[high]
    local i = low - 1
    for j = low, high - 1 do
        if v[j] < pivot then
            i = i + 1
            swap(v, i, j)
        end
    end
    swap(v, i + 1, high)
    return i + 1
end

function heapSort(v)
    local n = #v
    for i = math.floor(n / 2) - 1, 0, -1 do
        heapify(v, n, i)
    end
    for i = n, 2, -1 do
        swap(v, 1, i)
        heapify(v, i - 1, 0)
    end
end

function heapify(v, n, i)
    local largest = i
    local l, r = 2 * i + 1, 2 * i + 2
    if l < n and v[l + 1] > v[largest + 1] then largest = l end
    if r < n and v[r + 1] > v[largest + 1] then largest = r end
    if largest ~= i then
        swap(v, i + 1, largest + 1)
        heapify(v, n, largest)
    end
end

function shellSort(v)
    local n = #v
    local gap = math.floor(n / 2)
    while gap > 0 do
        for i = gap + 1, n do
            local temp = v[i]
            local j = i
            while j >= gap + 1 and v[j - gap] > temp do
                v[j] = v[j - gap]
                j = j - gap
            end
            v[j] = temp
        end
        gap = math.floor(gap / 2)
    end
end

function countingSort(v)
    local max = 0
    for _, num in ipairs(v) do
        if num > max then max = num end
    end
    local count = {}
    for i = 0, max do count[i] = 0 end
    for _, num in ipairs(v) do count[num] = count[num] + 1 end
    local idx = 1
    for i = 0, max do
        while count[i] > 0 do
            v[idx] = i
            idx = idx + 1
            count[i] = count[i] - 1
        end
    end
end

function radixSort(v)
    local max = 0
    for _, num in ipairs(v) do
        if num > max then max = num end
    end
    local exp = 1
    while math.floor(max / exp) > 0 do
        local output = {}
        local count = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
        for _, num in ipairs(v) do
            local d = math.floor(num / exp) % 10
            count[d + 1] = count[d + 1] + 1
        end
        for i = 2, 10 do count[i] = count[i] + count[i - 1] end
        for i = #v, 1, -1 do
            local d = math.floor(v[i] / exp) % 10
            output[count[d + 1]] = v[i]
            count[d + 1] = count[d + 1] - 1
        end
        for i = 1, #v do v[i] = output[i] end
        exp = exp * 10
    end
end

function bucketSort(v)
    local n = #v
    if n <= 0 then return end
    local max, min = v[1], v[1]
    for _, num in ipairs(v) do
        if num > max then max = num end
        if num < min then min = num end
    end
    local bc = math.floor(math.sqrt(n)) + 1
    local range = math.floor((max - min) / bc) + 1
    local buckets = {}
    for i = 1, bc do buckets[i] = {} end
    for _, num in ipairs(v) do
        local idx = math.floor((num - min) / range) + 1
        if idx > bc then idx = bc end
        table.insert(buckets[idx], num)
    end
    local pos = 1
    for i = 1, bc do
        if #buckets[i] > 0 then
            table.sort(buckets[i])
            for _, num in ipairs(buckets[i]) do
                v[pos] = num
                pos = pos + 1
            end
        end
    end
end

function printArray(v)
    for i, val in ipairs(v) do
        io.write(val .. " ")
    end
    io.write("\n")
end

io.write("--- ALGORITMOS DE ORDENACAO (LUA) ---\n")
io.write("Digite o tamanho do vetor: ")
local size = tonumber(io.read()) or 10
if size <= 0 then size = 10 end

local vet = {}
for i = 1, size do
    vet[i] = math.random(0, 999)
end

io.write("\nVetor original:\n")
printArray(vet)

io.write("\n1  - Bubble Sort\n")
io.write("2  - Selection Sort\n")
io.write("3  - Insertion Sort\n")
io.write("4  - Merge Sort\n")
io.write("5  - Quick Sort\n")
io.write("6  - Heap Sort\n")
io.write("7  - Shell Sort\n")
io.write("8  - Counting Sort\n")
io.write("9  - Radix Sort\n")
io.write("10 - Bucket Sort\n")
io.write("0  - Sair\n")
io.write("Opcao: ")
local opcao = tonumber(io.read()) or 0

if opcao == 0 then
    io.write("Saindo...\n")
    return
end

local copy = {}
for i, val in ipairs(vet) do copy[i] = val end

if opcao == 1 then bubbleSort(copy)
elseif opcao == 2 then selectionSort(copy)
elseif opcao == 3 then insertionSort(copy)
elseif opcao == 4 then mergeSort(copy, 1, size)
elseif opcao == 5 then quickSort(copy, 1, size)
elseif opcao == 6 then heapSort(copy)
elseif opcao == 7 then shellSort(copy)
elseif opcao == 8 then countingSort(copy)
elseif opcao == 9 then radixSort(copy)
elseif opcao == 10 then bucketSort(copy)
else
    io.write("Opcao invalida\n")
    return
end

io.write("\nVetor ordenado:\n")
printArray(copy)
