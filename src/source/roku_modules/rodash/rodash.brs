' Adds two numbers.
' @since 0.0.21
' @category Math
' @param {Dynamic} augend - The first number in an addition
' @param {Dynamic} addend - The second number in an addition
' @returns {Dynamic} Returns the total
' @example
' rodash.add(1, 2) // => 3
function rodash_add(augend, addend)
    value = 0
    if (type(augend) = "Integer" OR type(augend) = "roInt" OR type(augend) = "roInteger" OR type(augend) = "LongInteger" OR type(augend) = "Float" OR type(augend) = "roFloat" OR type(augend) = "Double" OR type(augend) = "roDouble" OR type(augend) = "roIntrinsicDouble") then
        value += augend
    end if
    if (type(addend) = "Integer" OR type(addend) = "roInt" OR type(addend) = "roInteger" OR type(addend) = "LongInteger" OR type(addend) = "Float" OR type(addend) = "roFloat" OR type(addend) = "Double" OR type(addend) = "roDouble" OR type(addend) = "roIntrinsicDouble") then
        value += addend
    end if
    return value
end function

' Returns a formatted version of the current time/date.
' @since 0.0.21
' @category Date
' @param {String} format - The date format
' @returns {Object} value - Returns a object containing the formatted date for both UTC and Local time
function rodash_asDateString(format = "long-date" as string) as object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.asDateString(format)
        "local": dateObj.local.asDateString(format)
    }
end function

' Returns the current time in seconds.
' @since 0.0.21
' @category Date
' @returns {Object} value - Returns a object containing the date/time in seconds for both UTC and Local time
function rodash_asSeconds() as object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.asSeconds()
        "local": dateObj.local.asSeconds()
    }
end function

' Assigns own enumerable string keyed properties of source objects to the destination object. Source objects are applied from left to right. Subsequent sources overwrite property assignments of previous sources.
' This method mutates object and is loosely based on lodash Object.assign.
' @since 0.0.21
' @category Object
' @param {Dynamic} baseAA - The destination object
' @params {Object} sources - The source objects
' @params {Dynamic} Mutaded baseAA
' @returns {Dynamic} Returns the destination object
' @example
' rodash.assign({ 'a': 0 }, { 'b': 1 }, { 'a': 2 }) // => { 'a': 2, 'b': 1 }
function rodash_assign(baseAA as Dynamic, sources = Invalid as Dynamic) as Dynamic
    if NOT (type(baseAA) = "roAssociativeArray") then
        return Invalid
    end if
    if (type(sources) = "roArray" AND NOT sources.isEmpty()) then
        for each source in sources
            if (type(source) = "roAssociativeArray" AND source.keys().count() > 0) then
                baseAA.append(source)
            end if
        end for
    end if
    return baseAA
end function

' Creates an array of values corresponding to paths of object.
' @since 0.0.21
' @category Object
' @param {AssocArray} obj - The object to iterate over.
' @param {Array} paths - The property paths to pick.
' @returns {Array} Returns the picked values.
' @example
' rodash.at({a: {b: 2}}, ["a.b"])
' // [2]
' rodash.at({a: {b: 2}}, ["a.b", "a.c"])
' // [2, invalid]
function rodash_at(obj as Object, paths as Object)
    returnArray = CreateObject("roArray", 0, true)
    if NOT (type(obj) = "roAssociativeArray" AND obj.keys().count() > 0) OR (type(paths) = "roArray" AND NOT paths.isEmpty()) then
        return returnArray
    end if
    for each path in paths
        result = rodash_get(obj, path)
        returnArray.push(result)
    end for
    return returnArray
end function

' Converts a string to camel case. Removes special characters and spaces.
' @since 0.0.21
' @category String
' @param {String} value - The string to convert.
' @returns {String} The camel case string.
' @example
' rodash.camelCase("Foo Bar") // => "fooBar"
' rodash.camelCase("foo/bar") // => "fooBar"
function rodash_camelCase(value = "" as String)
    regex = CreateObject("roRegex", "[^a-zA-Z0-9\s]", "")
    value = regex.ReplaceAll(value.trim(), "")
    valueArray = value.split(" ")
    responseValue = ""
    for i = 0 to valueArray.count() - 1
        valueString = valueArray[i]
        if i = 0 then
            responseValue += lcase(valueString)
        else
            responseValue += rodash_capitalize(valueString)
        end if
    end for
    return responseValue
end function

' Capitalizes the first letter of a string.
' @since 0.0.21
' @category String
' @param {String} value - The string to capitalize.
' @returns {String} The capitalized string.
' @example
' rodash.capitalize("foo bar") // => "Foo bar"
function rodash_capitalize(value = "" as String)
    if value = " " then
        return value
    end if
    value = value.trim()
    valueArray = value.split("")
    responseValue = ""
    for i = 0 to valueArray.count() - 1
        valueString = valueArray[i]
        if i = 0 then
            responseValue += ucase(valueString)
        else
            responseValue += lcase(valueString)
        end if
    end for
    return responseValue
end function

' Computes number rounded up to precision.
' @since 0.0.21
' @category Math
' @param {Integer} number - The number to round up
' @param {Integer} precision - The precision to round up to
' @returns {Integer} Returns the rounded up number
' @example
' rodash.ceil(4.006) // => 5
' rodash.ceil(0.056789, 4) // => 0.0568
function rodash_ceil(number = 0, precision = 0 as Dynamic) as Dynamic
    return abs(int(-number * 10 ^ precision)) / 10 ^ precision
end function

' Creates an array of elements split into groups the length of size. If array can't be split evenly, the final chunk will be the remaining elements.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to process
' @param {Integer} chunkSize - The length of each chunk
' @returns {Array} Returns the new array of chunks
' @example
' rodash.chunk([1, 2, 3, 4, 5], 2) // => [[1, 2], [3, 4], [5]]
' rodash.chunk([1, 2, 3, 4, 5], 3) // => [[1, 2, 3], [4, 5]]
function rodash_chunk(array as Object, chunkSize = 1 as Integer) as Object
    if NOT (type(array) = "roArray" AND NOT array.isEmpty()) then
        return CreateObject("roArray", 0, true)
    end if
    array = rodash_clone(array)
    numberOfChunks = rodash_floor(array.count() / chunkSize)
    returnArray = CreateObject("roArray", numberOfChunks, true)
    arrayIndex = 0
    for index = 0 to numberOfChunks
        chunkArray = CreateObject("roArray", 0, true)
        for i = 0 to chunkSize - 1
            chunkArray.push(array[arrayIndex])
            arrayIndex++
            if arrayIndex = array.count() then
                exit for
            end if
        end for
        returnArray[index] = chunkArray
        if arrayIndex = array.count() then
            exit for
        end if
    end for
    return returnArray
end function

' Clamps number within the inclusive lower and upper bounds.
' @since 0.0.21
' @category Number
' @param {Integer} number - The number to clamp
' @param {Integer} lower - The lower bound
' @param {Integer} upper - The upper bound
' @returns {Integer} Returns the clamped number
' @example
' rodash.clamp(-10, -5, 5) // => -5
' rodash.clamp(10, -5, 5) // => 5
function rodash_clamp(number, lower, upper) as Dynamic
    return (rodash_maxBy([
        lower
        rodash_min([
            upper
            number
        ])
    ]))
end function

' Creates a shallow clone of value.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - The value to be cloned
' @returns {Dynamic} The cloned value
function rodash_clone(value = Invalid as Dynamic) as Dynamic
    if (type(value) = "<uninitialized>" OR value = Invalid)
        return Invalid
    end if
    clonedValue = Invalid
    if (type(value) = "String" OR type(value) = "roString") then
        clonedValue = "" + value
    else if (type(value) = "roAssociativeArray") then
        clonedValue = CreateObject("roAssociativeArray")
        clonedValue.append(value)
    else if (type(value) = "roArray") then
        clonedValue = CreateObject("roArray", value.count(), true)
        clonedValue.append(value)
    else if (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble") then
        clonedValue = 0 + value
    else if (type(value) = "Boolean" OR type(value) = "roBoolean") then
        clonedValue = false OR value
    else if rodash_isNode(value) then
        clonedValue = value.clone(true)
    end if
    return clonedValue
end function

' Creates an array with all falsey values removed. The values false, 0, "", and invalid are falsey.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to compact
' @returns {Array} Returns the new array of filtered values
' @example
' rodash.compact([0, 1, false, 2, '', 3]) // => [1, 2, 3]
function rodash_compact(array as Object) as Object
    returnArray = CreateObject("roArray", 0, true)
    if (type(array) = "roArray" AND NOT array.isEmpty()) then
        for each item in array
            shallPass = true
            typeName = type(item)
            if (type(item) = "<uninitialized>" OR item = Invalid) then
                shallPass = false
            else if (rodash_isString(item) AND item.isEmpty()) then
                shallPass = false
            else if (type(item) = "Integer" OR type(item) = "roInt" OR type(item) = "roInteger" OR type(item) = "LongInteger" OR type(item) = "Float" OR type(item) = "roFloat" OR type(item) = "Double" OR type(item) = "roDouble" OR type(item) = "roIntrinsicDouble") then
                if item = 0 then
                    shallPass = false
                end if
            else if (type(item) = "Boolean" OR type(item) = "roBoolean") then
                shallPass = item
            end if
            if shallPass then
                returnArray.push(item)
            end if
        end for
    end if
    return returnArray
end function

' Creates a new array concatenating array with any additional arrays and/or values.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to concatenate
' @param {Array} values - The values to concatenate
' @returns {Array} Returns the new concatenated array
' @example
' rodash.concat([1], [2, [3], [[4]]]) // => [1, 2, [3], [[4]]]
function rodash_concat(array as Object, values as Object) as Object
    returnArray = CreateObject("roArray", 0, true)
    returnArray.append(array)
    if (type(array) = "roArray") AND (type(values) = "roArray") then
        for each value in values
            if (type(value) = "roArray") then
                returnArray.append(value)
            else
                returnArray.push(value)
            end if
        end for
    end if
    return returnArray
end function

' Invokes func after wait milliseconds. Any additional arguments are provided to func when it's invoked.
' @since 0.0.22
' @category Function
' @param {Sub} callback - The function sub to be called after a set delay
' @param {Float} [wait] - The number of milliseconds to delay
' @param {Object} options - The options object
' @param {Dynamic} options[context] - The context to be used when calling the callback
' @param {Float} options[maxWait] - The maximum time the sub is allowed to be delayed before it's invoked.
sub rodash_debounce(callback as Function, wait = 0 as dynamic, options = {
    maxWait: -1
} as object)
    id = "__debounce_" + callback.toStr()
    duration = bslib_ternary(wait = 0, 0.001, wait / 1000)
    if m[id] = invalid then
        timer = createObject("RoSGNode", "Timer")
        timer.update({
            duration: duration
            id: id
        }, true)
        m[id] = {
            callback: callback
            timer: timer
            timespan: CreateObject("roTimeSpan")
            context: rodash_get(options, "context", {})
        }
        m[id].timespan.mark()
        timer.observeFieldScoped("fire", (sub(event as object)
            id = event.getRoSgNode().id
            container = m[id]
            callback = container.callback
            callback(container.context)
            container.timer.unobserveFieldScoped("fire")
            m.delete(id)
        end sub).toStr().mid(10))
    end if
    if m[id] <> invalid then
        maxWait = rodash_get(options, "maxWait", -1)
        if maxWait > 0 and m[id].timespan.TotalMilliseconds() >= maxWait then
            m[id].timespan.mark()
            container = m[id]
            callback = container.callback
            callback(container.context)
            container.timer.unobserveFieldScoped("fire")
            m.delete(id)
        else
            timer = m[id].timer
            timer.duration = duration
            timer.control = "start"
        end if
    end if
end sub
' Deburrs string by converting Latin-1 Supplement and Latin Extended-A letters to basic Latin letters and removing combining diacritical marks.
' @since 0.0.30
' @category String
' @param {String} input - The string to deburr
' @returns {String} Returns the deburred string
' @example
' deburr("déjà vu") ' => "deja vu"
function rodash_deburr(input = "" as String)
    ' Create an associative array (dictionary) to map accented characters to basic Latin letters
    latinMap = {}
    latinMap.SetModeCaseSensitive()
    latinMap.append({
        "À": "A"
        "Á": "A"
        "Â": "A"
        "Ã": "A"
        "Ä": "A"
        "Å": "A"
        "Æ": "Ae"
        "Ç": "C"
        "È": "E"
        "É": "E"
        "Ê": "E"
        "Ë": "E"
        "Ì": "I"
        "Í": "I"
        "Î": "I"
        "Ï": "I"
        "Ð": "D"
        "Ñ": "N"
        "Ò": "O"
        "Ó": "O"
        "Ô": "O"
        "Õ": "O"
        "Ö": "O"
        "Ø": "O"
        "Ù": "U"
        "Ú": "U"
        "Û": "U"
        "Ü": "U"
        "Ý": "Y"
        "Þ": "TH"
        "ß": "ss"
        "à": "a"
        "á": "a"
        "â": "a"
        "ã": "a"
        "ä": "a"
        "å": "a"
        "æ": "ae"
        "ç": "c"
        "è": "e"
        "é": "e"
        "ê": "e"
        "ë": "e"
        "ì": "i"
        "í": "i"
        "î": "i"
        "ï": "i"
        "ð": "d"
        "ñ": "n"
        "ò": "o"
        "ó": "o"
        "ô": "o"
        "õ": "o"
        "ö": "o"
        "ø": "o"
        "ù": "u"
        "ú": "u"
        "û": "u"
        "ü": "u"
        "ý": "y"
        "þ": "th"
        "ÿ": "y"
        "Ā": "A"
        "ā": "a"
        "Ă": "A"
        "ă": "a"
        "Ą": "A"
        "ą": "a"
        "Ć": "C"
        "ć": "c"
        "Ĉ": "C"
        "ĉ": "c"
        "Ċ": "C"
        "ċ": "c"
        "Č": "C"
        "č": "c"
        "Ď": "D"
        "ď": "d"
        "Đ": "D"
        "đ": "d"
        "Ē": "E"
        "ē": "e"
        "Ĕ": "E"
        "ĕ": "e"
        "Ė": "E"
        "ė": "e"
        "Ę": "E"
        "ę": "e"
        "Ě": "E"
        "ě": "e"
        "Ĝ": "G"
        "ĝ": "g"
        "Ğ": "G"
        "ğ": "g"
        "Ġ": "G"
        "ġ": "g"
        "Ģ": "G"
        "ģ": "g"
        "Ĥ": "H"
        "ĥ": "h"
        "Ħ": "H"
        "ħ": "h"
        "Ĩ": "I"
        "ĩ": "i"
        "Ī": "I"
        "ī": "i"
        "Ĭ": "I"
        "ĭ": "i"
        "Į": "I"
        "į": "i"
        "İ": "I"
        "ı": "i"
        "Ĳ": "IJ"
        "ĳ": "ij"
        "Ĵ": "J"
        "ĵ": "j"
        "Ķ": "K"
        "ķ": "k"
        "ĸ": "k"
        "Ĺ": "L"
        "ĺ": "l"
        "Ļ": "L"
        "ļ": "l"
        "Ľ": "L"
        "ľ": "l"
        "Ŀ": "L"
        "ŀ": "l"
        "Ł": "L"
        "ł": "l"
        "Ń": "N"
        "ń": "n"
        "Ņ": "N"
        "ņ": "n"
        "Ň": "N"
        "ň": "n"
        "ŉ": "n"
        "Ō": "O"
        "ō": "o"
        "Ŏ": "O"
        "ŏ": "o"
        "Ő": "O"
        "ő": "o"
        "Œ": "OE"
        "œ": "oe"
        "Ŕ": "R"
        "ŕ": "r"
        "Ŗ": "R"
        "ŗ": "r"
        "Ř": "R"
        "ř": "r"
        "Ś": "S"
        "ś": "s"
        "Ŝ": "S"
        "ŝ": "s"
        "Ş": "S"
        "ş": "s"
        "Š": "S"
        "š": "s"
        "Ţ": "T"
        "ţ": "t"
        "Ť": "T"
        "ť": "t"
        "Ŧ": "T"
        "ŧ": "t"
        "Ũ": "U"
        "ũ": "u"
        "Ū": "U"
        "ū": "u"
        "Ŭ": "U"
        "ŭ": "u"
        "Ů": "U"
        "ů": "u"
        "Ű": "U"
        "ű": "u"
        "Ų": "U"
        "ų": "u"
        "Ŵ": "W"
        "ŵ": "w"
        "Ŷ": "Y"
        "ŷ": "y"
        "Ÿ": "Y"
        "Ź": "Z"
        "ź": "z"
        "Ż": "Z"
        "ż": "z"
        "Ž": "Z"
        "ž": "z"
    })
    normalizedString = ""
    ' Iterate over each character, checking if it needs replacement
    for i = 0 to len(input) - 1
        char = mid(input, i + 1, 1) ' Use i+1 to correctly get the current character
        if latinMap.doesExist(char)
            normalizedString = normalizedString + latinMap[char]
        else
            normalizedString = normalizedString + char
        end if
    end for
    return normalizedString
end function

' Invokes sub after wait milliseconds. Any additional arguments are provided to subwhen it's invoked.
' @since 0.0.22
' @category Function
' @param {Sub} callback - The sub to be called after a set delay
' @param {Float} [wait] - The number of milliseconds to delay invocation
' @param {Dynamic} context - a single item of data to be passed into the callback when invoked
sub rodash_delay(callback as Function, wait = 0 as float, context = invalid as dynamic)
    duration = bslib_ternary(wait = 0, 0.0001, wait / 1000)
    timer = createObject("RoSGNode", "Timer")
    timer.update({
        duration: duration
        repeat: false
        id: "__delay_" + createObject("roDeviceInfo").getRandomUUID()
    })
    m[timer.id] = {
        timer: timer
        callback: callback
        context: context
    }
    timer.observeFieldScoped("fire", (sub(event as object)
        delayId = event.getNode()
        options = m[delayId]
        callback = options.callback
        try
            callback(options.context)
        catch e
            print "Crash during utils.delay:"
            print e
        end try
        m[delayId].timer.unobserveFieldScoped("fire")
        m.delete(delayId)
    end sub).toStr().mid(10))
    timer.control = "start"
end sub
' Creates an array of array values not included in the other given arrays using SameValueZero for equality comparisons. The order and references of result values are determined by the first array.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to inspect
' @param {Array} values - The values to exclude
' @returns {Array} Returns the new array of filtered values
' @example
' rodash.difference([2, 1], [2, 3]) // => [1]
function rodash_difference(array = CreateObject("roArray", 0, true) as Object, values = CreateObject("roArray", 0, true) as Object) as Object
    return rodash_differenceBy(array, values)
end function

' This method is like rodash.difference except that it accepts iteratee which is invoked for each element of array and values to generate the criterion by which they're compared. The order and references of result values are determined by the first array. The iteratee is invoked with one argument:(value).
' @since 0.0.21
' @category Array
' @param {Array} array - The array to inspect
' @param {Array} values - The values to exclude
' @param {Dynamic} iteratee - The iteratee invoked per element
' @returns {Array} Returns the new array of filtered values
' @example
' rodash.differenceBy([2.1, 1.2], [2.3, 3.4], rodash.floor) // => [1.2]
' rodash.differenceBy([{ 'x': 2 }, { 'x': 1 }], [{ 'x': 1 }], 'x') // => [{ 'x': 2 }]
function rodash_differenceBy(array = CreateObject("roArray", 0, true) as Object, values = CreateObject("roArray", 0, true) as Object, iteratee = Invalid) as Object
    iterateeIsFunction = rodash_isFunction(iteratee)
    iterateeIsProperty = NOT iterateeIsFunction AND (type(iteratee) = "String" OR type(iteratee) = "roString")
    returnArray = CreateObject("roArray", 0, true)
    for each item in array
        convertedItem = item
        if iterateeIsFunction then
            convertedItem = iteratee(item)
        else if iterateeIsProperty then
            convertedItem = item[iteratee]
        end if
        found = false
        for each valueToMatch in values
            if iterateeIsFunction then
                valueToMatch = iteratee(valueToMatch)
            else if iterateeIsProperty
                valueToMatch = valueToMatch[iteratee]
            end if
            if convertedItem = valueToMatch then
                found = true
                exit for
            end if
        end for
        if NOT found then
            returnArray.push(item)
        end if
    end for
    return returnArray
end function

' This method is like rodash.difference except that it accepts comparator which is invoked to compare elements of array to values. The order and references of result values are determined by the first array. The comparator is invoked with two arguments: (arrVal, othVal).
' @since 0.0.21
' @category Array
' @param {Array} array - The array to inspect
' @param {Array} values - The values to exclude
' @param {Dynamic} iteratee - The iteratee invoked per element
' @returns {Array} Returns the new array of filtered values
' @example
' objects = [{ 'x': 1, 'y': 2 }, { 'x': 2, 'y': 1 }]
' rodash.differenceWith(objects, [{ 'x': 1, 'y': 2 }], rodash.isEqual)
' // => [{ 'x': 2, 'y': 1 }]
function rodash_differenceWith(array = CreateObject("roArray", 0, true) as Object, values = CreateObject("roArray", 0, true) as Object, comparator = Invalid) as Object
    returnArray = CreateObject("roArray", 0, true)
    if rodash_isFunction(comparator) then
        for i = 0 to array.count() - 1
            itemOne = array[0]
            itemTwo = array[1]
            if (type(itemOne) <> "<uninitialized>" AND itemOne <> Invalid) AND (type(itemTwo) <> "<uninitialized>" AND itemTwo <> Invalid) AND NOT rodash_isEqual(itemOne, itemTwo) then
                returnArray.push(itemOne)
            end if
        end for
    end if
    return returnArray
end function

' Divides two numbers
' @since 0.0.21
' @category Math
' @param {Dynamic} dividend - The first number in a division
' @param {Dynamic} divisor - The second number in a division
' @returns {Integer} Returns the quotient
' @example
' rodash.divide(6, 4) // => 1.5
function rodash_divide(dividend as Dynamic, divisor as Dynamic) as Dynamic
    if (NOT rodash_isNumber(dividend)) OR (NOT rodash_isNumber(divisor))
        return 0
    end if
    if (divisor <= 0) then
        return dividend
    end if
    return dividend / divisor
end function

' Creates a slice of array with n elements dropped from the beginning.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @param {Integer} n - The number of elements to drop
' @returns {Array} Returns the slice of array
' @example
' rodash.drop([1, 2, 3], 1) // => [2, 3]
function rodash_drop(array = CreateObject("roAssociativeArray") as Object, n = 1 as Integer)
    array = rodash_clone(array)
    for i = 0 to n - 1
        array.shift()
        if array.count() = 0 then
            exit for
        end if
    end for
    return array
end function

' Creates a slice of array with n elements dropped from the end.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @param {Integer} n - The number of elements to drop
' @returns {Array} Returns the slice of array
' @example
' rodash.dropRight([1, 2, 3], 1) // => [1, 2]
function rodash_dropRight(array = CreateObject("roAssociativeArray") as Object, n = 1 as Integer)
    array = rodash_clone(array)
    array.reverse()
    array = rodash_drop(array, n)
    array.reverse()
    return array
end function

' Creates a slice of array excluding elements dropped from the end. Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @param {Dynamic} predicate - The function invoked per iteration
' @returns {Array} Returns the slice of array
function rodash_dropRightWhile(array = CreateObject("roAssociativeArray") as Object, predicate = Invalid)
    array = rodash_clone(array)
    array.reverse()
    array = rodash_dropWhile(array, predicate)
    array.reverse()
    return array
end function

' Creates a slice of array excluding elements dropped from the beginning. Elements are dropped until predicate returns falsey. The predicate is invoked with three arguments: (value, index, array).
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @param {Dynamic} predicate - The function invoked per iteration
' @returns {Array} Returns the slice of array
function rodash_dropWhile(array = CreateObject("roArray", 0, true) as Object, predicate = Invalid)
    array = rodash_clone(array)
    for i = 0 to array.count() - 1
        item = array[i]
        if rodash_isFunction(predicate) then
            if NOT predicate(item) then
                return rodash_slice(array, i)
            end if
        else if (type(predicate) = "roAssociativeArray") then
            if NOT rodash_isEqual(item, predicate) then
                return rodash_slice(array, i)
            end if
        else if (type(predicate) = "roArray") then
            if NOT rodash_isEqual(item[predicate[0]], predicate[1]) then
                return rodash_slice(array, i)
            end if
        else if (type(predicate) = "String" OR type(predicate) = "roString") then
            if NOT item[predicate] then
                return rodash_slice(array, i)
            end if
        end if
    end for
    return array
end function

' Checks if `string` ends with the given target string.
' @since 0.0.21
' @category String
' @param {String} source - The string to search.
' @param {String} target - The string to search for.
' @param {Number} position - The position to search up to.
' @returns {Boolean} Returns `true` if `string` ends with `target`, else `false`.
' @example
' rodash.endsWith("abc", "c") // => true
' rodash.endsWith("abc", "b") // => false
function rodash_endsWith(source = "" as String, target = "" as String, position = Invalid as Dynamic)
    if (type(position) = "<uninitialized>" OR position = Invalid) then
        position = source.len()
    end if
    return source.endsWith(target, position)
end function

' Checks if two values are equivalent.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - The value to compare.
' @param {Dynamic} other - The other value to compare.
' @returns {Boolean} Returns `true` if the values are equivalent, else `false`.
' @example
' rodash.eq(1, 1) // => true
' rodash.eq(1, 2) // => false
function rodash_eq(value as Dynamic, other as Dynamic)
    return rodash_isEqual(value, other)
end function

' Escapes a string for insertion into HTML, replacing &, <, >, ", `, and ' characters.
' @since 0.0.21
' @category String
' @param {String} source - The string to escape.
' @returns {String} The escaped string.
' @example
' rodash.escape("fred, barney, & pebbles") // => 'fred, barney, &amp; pebbles'
function rodash_escape(source = "" as String)
    return source.escape()
end function

' Escapes a string for insertion into a regular expression.
' @since 0.0.21
' @category String
' @param {String} source - The string to escape.
' @returns {String} The escaped string.
function rodash_escapeRegExp(source = "" as String)
    replaceArray = [
        "^"
        "$"
        ""
        "."
        "*"
        "+"
        "?"
        "("
        ")"
        "["
        "]"
        "{"
        "}"
        "|"
    ]
    for each char in replaceArray
        source = source.replace(char, "\" + char)
    end for
    return source.replace("\/\/", "//")
end function

' Fills elements of array with value from start up to, but not including, end.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to fill
' @param {Dynamic} value - The value to fill array with
' @param {Integer} startPos - The start position
' @param {Integer} endPos - The end position
' @returns {Array} Returns the mutated array
' @example
' rodash.fill([1, 2, 3], "a", 1, 2) // => [1, "a", 3]
' rodash.fill([1, 2, 3], "a") // => ["a", "a", "a"]
' rodash.fill([1, 2, 3], "a", 1) // => [1, "a", "a"]
function rodash_fill(array = CreateObject("roArray", 0, true) as Object, value = "" as Dynamic, startPos = Invalid, endPos = Invalid)
    if (type(startPos) = "<uninitialized>" OR startPos = Invalid) then
        startPos = 0
    end if
    if (type(endPos) = "<uninitialized>" OR endPos = Invalid) then
        endPos = array.count()
    end if
    endPos = endPos - 1
    for i = startPos to endPos
        array[i] = value
    end for
    return array
end function

' Iterates over elements of collection, returning the first element predicate returns truthy for. The predicate is invoked with three arguments: (value, index|key, collection).
' @since 0.0.22
' @category Collection
' @param {Array} array - The array to inspect
' @param {Dynamic} predicate - The function invoked per iteration
' @param {Integer} fromIndex - The index to search from
' @returns {Dymanic} Returns the matched element, else invalid.
' @example
' users = [
'   { "user": "barney", "active": false },
'   { "user": "fred", "active": false },
'   { "user": "pebbles", "active": true }
' ]
'
' rodash.find(users, function(o)
'   return o.user = "barney"
' end function)
' // => { "user": "barney", "active": false }
function rodash_find(array, predicate = Invalid as Dynamic, fromIndex = 0 as Integer) as Dynamic
    if NOT (type(array) = "roArray") then
        return Invalid
    end if
    foundIndex = rodash_findIndex(array, predicate, fromIndex)
    if foundIndex = -1 then
        return Invalid
    end if
    return array[foundIndex]
end function

' This method is like rodash.find except that it returns the index of the first element predicate returns truthy for instead of the element itself.
' By default, when comparing arrays and associative arrays the function will compare the values on the elements. If the strict parameter is set to true, the function will compare the references of the AA and Array elements.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to inspect
' @param {Dynamic} predicate - The function invoked per iteration
' @param {Integer} fromIndex - The index to search from
' @param {Boolean} strict - If true, the function will compare the references of the AA and Array elements
' @returns {Integer} Returns the index of the found element, else -1
function rodash_findIndex(array, predicate = Invalid as Dynamic, fromIndex = 0 as Integer, strict = false as Boolean) as Integer
    for index = fromIndex to array.count() - 1
        item = array[index]
        if rodash_internal_canBeCompared(item, predicate) then
            if rodash_isEqual(item, predicate) then
                return index
            end if
        else if rodash_isFunction(predicate) then
            if predicate(item) then
                return index
            end if
        else if (type(predicate) = "roAssociativeArray") then
            if rodash_isEqual(item, predicate, strict) then
                return index
            end if
        else if (type(predicate) = "roArray") then
            if rodash_isEqual(item[predicate[0]], predicate[1], strict) then
                return index
            end if
            if (type(item) = "roArray") AND rodash_isEqual(item, predicate, strict) then
                return index
            end if
        else if (type(item) = "roAssociativeArray") AND (type(predicate) = "String" OR type(predicate) = "roString") AND item.doesExist(predicate) then
            if item[predicate] then
                return index
            end if
        end if
    end for
    return -1
end function

' This method is like rodash.findIndex except that it iterates over elements of collection from right to left.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to inspect
' @param {Dynamic} predicate - The function invoked per iteration
' @param {Integer} fromIndex - The index to search from
' @returns {Integer} Returns the index of the found element, else -1
function rodash_findLastIndex(array, predicate = Invalid, fromIndex = 0 as Integer)
    array = rodash_clone(array)
    array.reverse()
    foundIndex = rodash_findIndex(array, predicate, fromIndex)
    if foundIndex = -1 then
        return -1
    end if
    return array.count() - 1 - foundIndex
end function

' An alias to the head function.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @returns {Dynamic} Returns the first element of array
' @example
' rodash.first([1, 2, 3]) // => 1
' rodash.first([]) // => Invalid
function rodash_first(array = CreateObject("roArray", 0, true))
    return (array[0])
end function

' Flattens array a single level deep.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to flatten
' @returns {Dynamic} Returns the new flattened array
' @example
' rodash.flatten([1, [2, [3, [4]], 5]]) // => [1, 2, [3, [4]], 5]
function rodash_flatten(array = CreateObject("roArray", 0, true) as Object) as Object
    returnArray = CreateObject("roArray", 0, true)
    for each item in array
        if type(item) = "roArray" then
            returnArray.append(item)
        else
            returnArray.push(item)
        end if
    end for
    return returnArray
end function

' Recursively flattens array.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to flatten
' @returns {Dynamic} Returns the new flattened array
' @example
' rodash.flattenDeep([1, [2, [3, [4]], 5]]) ' => [1, 2, 3, 4, 5]
' rodash.flattenDeep([1, [2, [3, [4]], 5], 6]) ' => [1, 2, 3, 4, 5, 6]
function rodash_flattenDeep(array = CreateObject("roArray", 0, true))
    returnArray = CreateObject("roArray", 0, true)
    for each item in array
        if type(item) = "roArray" then
            returnArray.append(rodash_flattenDeep(item))
        else
            returnArray.push(item)
        end if
    end for
    return returnArray
end function

' Recursively flatten array up to depth times.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to flatten
' @param {Integer} depth - The maximum recursion depth
' @returns {Dynamic} Returns the new flattened array
function rodash_flattenDepth(array = Invalid, depth = 1 as Integer)
    returnArray = CreateObject("roArray", 0, true)
    if NOT (type(array) = "roArray") then
        return array
    end if
    for i = 0 to array.count() - 1
        item = array[i]
        if (depth > 1) then
            item = rodash_flattenDepth(item, depth - 1)
            if (type(item) = "roArray") then
                returnArray.append(item)
            else
                returnArray.push(item)
            end if
        else
            if (type(item) = "roArray") then
                returnArray.append(item)
            else
                returnArray.push(item)
            end if
        end if
    end for
    return returnArray
end function

' Computes number rounded down to precision
' @since 0.0.21
' @category Math
' @param {Integer} number - The number to round down
' @param {Integer} precision - The precision to round down to
' @returns {Integer} Returns the rounded down number
' @example
' rodash.floor(4.006) // => 4
' rodash.floor(0.046, 2) // => 0.04
' rodash.floor(4060, -2) // => 4000
function rodash_floor(number = 0, precision = 0 as Dynamic) as Dynamic
    return abs(int(number * 10 ^ precision)) / 10 ^ precision
end function

' Iterates over elements of collection and invokes iteratee for each element. The iteratee is invoked with three arguments: (value, index|key, collection). Iteratee functions may exit iteration early by explicitly returning false.
' Note: As with other "Collections" methods, objects with a "length" property are iterated like arrays. To avoid this behavior use rodash.forIn or rodash.forOwn for object iteration.
' @since 0.0.21
' @category Collection
' @param {Dynamic} collection - The collection to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @returns {Dynamic} Returns collection
' @example
' rodash.forEach([1, 2], function(value)
'   print value
' end function)
' // => Logs `1` then `2`
function rodash_forEach(collection = Invalid as Dynamic, iteratee = Invalid as Dynamic)
    return rodash_internal_baseForEach(collection, iteratee)
end function

' This method is like rodash.forEach except that it iterates over elements of collection from right to left.
' @since 0.0.21
' @category Collection
' @param {Dynamic} collection - The collection to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @returns {Dynamic} Returns collection
' @example
' rodash.forEachRight([1, 2], function(value)
'   print value
' end function)
' // => Logs `2` then `1`
function rodash_forEachRight(collection = Invalid as Dynamic, iteratee = Invalid as Dynamic)
    return rodash_internal_baseForEach(collection, iteratee, "right")
end function

' Iterates over own and inherited enumerable string keyed properties of an object and invokes iteratee for each property. The iteratee is invoked with three arguments: (value, key, object). Iteratee functions may exit iteration early by explicitly returning false.
' @since 0.0.21
' @category Object
' @param {Dynamic} obj - The object to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @returns {Object} Returns object
function rodash_forIn(obj = CreateObject("roAssociativeArray") as Object, iteratee = Invalid as Dynamic)
    return rodash_internal_baseForEach(obj, iteratee, "left", "omit")
end function

' This method is like rodash.forIn except that it iterates over properties of object in the opposite order.
' @since 0.0.21
' @category Object
' @param {Dynamic} obj - The object to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @returns {Object} Returns object
' @example
' rodash.forInRight({ 'a': 1, 'b': 2 }, function(value, key)
'   print key
' end function)
' // => Logs `b` then `a`
function rodash_forInRight(obj = CreateObject("roAssociativeArray") as Object, iteratee = Invalid as Dynamic)
    return rodash_internal_baseForEach(obj, iteratee, "right", "omit")
end function

' Iterates over own enumerable string keyed properties of an object and invokes iteratee for each property. The iteratee is invoked with three arguments: (value, key, object). Iteratee functions may exit iteration early by explicitly returning false.
' @since 0.0.21
' @category Object
' @param {Dynamic} obj - The object to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @returns {Object} Returns object
function rodash_forOwn(obj = CreateObject("roAssociativeArray") as Object, iteratee = Invalid as Dynamic)
    return rodash_internal_baseForEach(obj, iteratee, "left", "omit")
end function

' This method is like rodash.forOwn except that it iterates over properties of object in the opposite order.
' @since 0.0.21
' @category Object
' @param {Dynamic} obj - The object to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @returns {Object} Returns object
function rodash_forOwnRight(obj = CreateObject("roAssociativeArray") as Object, iteratee = Invalid as Dynamic)
    return rodash_internal_baseForEach(obj, iteratee, "right", "omit")
end function

' Converts an ISO 8601 string to a date object.
' @since 0.0.21
' @category Date
' @param {String} dateString - The date string to convert.
' @returns {Object} The date objects.
function rodash_fromISO8601String(dateString = "" as String) as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.fromISO8601String(dateString)
        "local": dateObj.local.fromISO8601String(dateString)
    }
end function

' The inverse of rodash.toPairs; this method returns an object composed from key-value pairs.
' @since 0.0.24
' @category Array
' @param {Array} pairs - And array of arrays to be converted to an object
' @returns {Object} Returns the new object
function rodash_fromPairs(pairs = CreateObject("roArray", 0, true) as Object) as Object
    returnObject = CreateObject("roAssociativeArray")
    if NOT (type(pairs) = "roArray") then
        return returnObject
    end if
    for each pair in pairs
        if (type(pair) = "roArray") AND pair.count() = 2 then
            returnObject[pair[0]] = pair[1]
        end if
    end for
    return returnObject
end function

' Converts a number of seconds to a date object.
' @since 0.0.21
' @category Date
' @param {Number} numSeconds - The number of seconds to convert.
' @returns {Object} The date objects.
function rodash_fromSeconds(numSeconds = 0 as Integer) as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.fromSeconds(numSeconds)
        "local": dateObj.local.fromSeconds(numSeconds)
    }
end function

' TODO: Rewrite this due to scoping issue
' @ignore
' Creates an array of function property names from own enumerable properties of object.
' @category Object
' @param {Dynamic} obj - The object to iterate over
' @returns {Object} Returns object
function rodash_functions(obj = CreateObject("roAssociativeArray") as Object)
    ' return rodash.base.forEach.baseForEach(obj, invalid, "left", "only")
    return []
end function

' TODO: Rewrite this due to scoping issue
' @ignore
' Creates an array of function property names from own and inherited enumerable properties of object.
' @param {Dynamic} obj - The object to iterate over
' @returns {Object} Returns object
function rodash_functionsIn(obj = CreateObject("roAssociativeArray") as Object)
    ' return rodash.base.forEach.baseForEach(obj, invalid, "left", "only")
    return []
end function

' Gets the value at path of object. If the resolved value is undefined, the defaultValue is returned in its place.
' @since 0.0.21
' @category Object
' @param {Object} aa - Object to drill down into.
' @param {String} keyPath - A dot notation based string to the expected value.
' @param {Dynamic} fallback - A return fallback value if the requested field could not be found or did not pass the validator function.
' @param {Function} validator - A function used to validate the output value matches what you expected.
' @returns {Dynamic} The result of the drill down process
' @example
' rodash.get({a: {b: {c: 3}}}, 'a.b.c') ' => 3
' rodash.get({a: {b: {c: 3}}}, 'a.b.d') ' => invalid
' rodash.get({a: {b: {c: 3}}}, 'a.b.d', 'default') ' => 'default'
' rodash.get({a: {b: {c: 3}}}, 'a.b.c', -1, rodash.isNumber) ' => 3
' rodash.get({a: {b: {c: 3}}}, 'a.b.d', -1, rodash.isNumber) ' => -1
function rodash_get(aa as Object, keyPath as String, fallback = Invalid as Dynamic, validator = rodash_isNotInvalid as Function) as Dynamic
    nextValue = aa
    lookupSucceeded = true
    for each key in keyPath.tokenize(".")
        if (getInterface(nextValue, "ifAssociativeArray") <> Invalid) then
            nextValue = nextValue[key]
        else if type(nextValue) = "roArray" AND NOT nextValue.isEmpty() then
            index = 0
            if (type(key) = "String" OR type(key) = "roString") then
                if key.instr(".") > -1 then
                    index = val(key)
                else
                    index = val(key, 10)
                end if
            else if (type(key) = "Integer" OR type(key) = "roInt" OR type(key) = "roInteger" OR type(key) = "LongInteger" OR type(key) = "Float" OR type(key) = "roFloat" OR type(key) = "Double" OR type(key) = "roDouble" OR type(key) = "roIntrinsicDouble") then
                index = key
            else if (type(key) = "Boolean" OR type(key) = "roBoolean") then
                if key then
                    index = 1
                end if
                index = 0
            end if
            nextValue = nextValue[index]
        else
            lookupSucceeded = false
            exit for
        end if
    end for
    if lookupSucceeded AND validator(nextValue) then
        return nextValue
    end if
    return fallback
end function

' Gets the AA value at path of object. Calls rodash.get with the isAA validator function.
' @since 0.0.25
' @category Object
' @param {Object} aa - Object to drill down into.
' @param {String} keyPath - A dot notation based string to the expected value.
' @param {Assocarray} fallback - A return fallback value if the requested field could not be found or did not pass the validator function.
' @returns {Assocarray} The result of the drill down process
' @example
' rodash.getAA({a: {b: {c: 3}}}, 'a.b') ' => {c: 3}
' rodash.getAA({a: {b: {c: 3}}}, 'a.b.d') ' => {}
' rodash.getAA({a: {b: {c: 3}}}, 'a.b.c') ' => {}
' rodash.getAA({a: {b: {c: 3}}}, 'a.b.d', {d: 4}) ' => {d: 4}
function rodash_getAA(aa as Object, keyPath as String, fallback = CreateObject("roAssociativeArray") as Object) as Object
    return rodash_get(aa, keyPath, fallback, rodash_isAA)
end function

' Gets the Array value at path of object. Calls rodash.get with the isArray validator function.
' @since 0.0.25
' @category Object
' @param {Object} aa - Object to drill down into.
' @param {String} keyPath - A dot notation based string to the expected value.
' @param {Array} fallback - A return fallback value if the requested field could not be found or did not pass the validator function.
' @returns {Array} The result of the drill down process
' @example
' rodash.getArray({a: {b: {c: [1, 2, 3]}}}, 'a.b.c') ' => [1, 2, 3]
' rodash.getArray({a: {b: {c: 3}}}, 'a.b.d') ' => []
' rodash.getArray({a: {b: {c: 3}}}, 'a.b.c') ' => []
' rodash.getArray({a: {b: {c: 3}}}, 'a.b.d', [1, 2, 3]) ' => [1, 2, 3]
function rodash_getArray(aa as Object, keyPath as String, fallback = CreateObject("roArray", 0, true) as Object) as Object
    return rodash_get(aa, keyPath, fallback, rodash_isArray)
end function

' Gets the boolean value at path of object. Calls rodash.get with the isBoolean validator function.
' @since 0.0.25
' @category Object
' @param {Object} aa - Object to drill down into.
' @param {String} keyPath - A dot notation based string to the expected value.
' @param {Boolean} fallback - A return fallback value if the requested field could not be found or did not pass the validator function.
' @returns {Boolean} The result of the drill down process
' @example
' rodash.getBoolean({a: {b: {c: true}}}, 'a.b.c') ' => true
' rodash.getBoolean({a: {b: {c: 3}}}, 'a.b.d') ' => false
' rodash.getBoolean({a: {b: {c: 3}}}, 'a.b.c') ' => false
' rodash.getBoolean({a: {b: {c: 3}}}, 'a.b.d', true) ' => true
function rodash_getBoolean(aa as Object, keyPath as String, fallback = false as Boolean) as Boolean
    return rodash_get(aa, keyPath, fallback, rodash_isBoolean)
end function

' Gets the day of the month.
' @since 0.0.21
' @category Date
' @returns {Object} The day of the month.
function rodash_getDayOfMonth() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getDayOfMonth()
        "local": dateObj.local.getDayOfMonth()
    }
end function

' Gets the day of the week.
' @since 0.0.21
' @category Date
' @returns {Object} The day of the week.
function rodash_getDayOfWeek() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getDayOfWeek()
        "local": dateObj.local.getDayOfWeek()
    }
end function

' Gets the function name from a function object.
' @since 0.0.26
' @category Lang
' @param {Object} call - function
' @returns {String} The function string name
function rodash_getFunctionName(call as Object) as String
    if rodash_isFunction(call) then
        return call.toStr().tokenize(" ").peek()
    end if
    return ""
end function

' Gets the hours.
' @since 0.0.21
' @category Date
' @returns {Object} The hours.
function rodash_getHours() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getHours()
        "local": dateObj.local.getHours()
    }
end function

' Gets the last day of the month.
' @since 0.0.21
' @category Date
' @returns {Object} The last day of the month.
function rodash_getLastDayOfMonth() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getLastDayOfMonth()
        "local": dateObj.local.getLastDayOfMonth()
    }
end function

' Gets the milliseconds.
' @since 0.0.21
' @category Date
' @returns {Object} The milliseconds.
function rodash_getMilliseconds() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getMilliseconds()
        "local": dateObj.local.getMilliseconds()
    }
end function

' Gets the minutes.
' @since 0.0.21
' @category Date
' @returns {Object} The minutes.
function rodash_getMinutes() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getMinutes()
        "local": dateObj.local.getMinutes()
    }
end function

' Gets the month.
' @since 0.0.21
' @category Date
' @returns {Object} The month.
function rodash_getMonth() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getMonth()
        "local": dateObj.local.getMonth()
    }
end function

' Gets the number value at path of object. Calls rodash.get with the isNumber validator function.
' @since 0.0.25
' @category Object
' @param {Object} aa - Object to drill down into.
' @param {String} keyPath - A dot notation based string to the expected value.
' @param {Number} fallback - A return fallback value if the requested field could not be found or did not pass the validator function.
' @returns {Number} The result of the drill down process
' @example
' rodash.getNumber({a: {b: {c: 3}}}, 'a.b.c') ' => 3
' rodash.getNumber({a: {b: {c: 3}}}, 'a.b.d') ' => 0
' rodash.getNumber({a: {b: {c: 3}}}, 'a.b.c') ' => 3
' rodash.getNumber({a: {b: {c: 3}}}, 'a.b.d', 25) ' => 25
function rodash_getNumber(aa as Object, keyPath as String, fallback = 0 as Dynamic) as Dynamic
    return rodash_get(aa, keyPath, fallback, rodash_isNumber)
end function

' Gets the seconds.
' @since 0.0.21
' @category Date
' @returns {Object} The seconds.
function rodash_getSeconds() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getSeconds()
        "local": dateObj.local.getSeconds()
    }
end function

' Gets the String value at path of object. Calls rodash.get with the isString validator function.
' @since 0.0.25
' @category Object
' @param {Object} aa - Object to drill down into.
' @param {String} keyPath - A dot notation based string to the expected value.
' @param {String} fallback - A return fallback value if the requested field could not be found or did not pass the validator function.
' @returns {String} The result of the drill down process
' @example
' rodash.getString({a: {b: {c: 'hello'}}}, 'a.b.c') ' => 'hello'
' rodash.getString({a: {b: {c: 3}}}, 'a.b.d') ' => ''
' rodash.getString({a: {b: {c: 3}}}, 'a.b.c') ' => ''
' rodash.getString({a: {b: {c: 3}}}, 'a.b.d', 'fallback') ' => 'fallback'
function rodash_getString(aa as Object, keyPath as String, fallback = "" as String) as String
    return rodash_get(aa, keyPath, fallback, rodash_isString)
end function

' Gets the year.
' @since 0.0.21
' @category Date
' @returns {Object} The year.
function rodash_getYear() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.getYear()
        "local": dateObj.local.getYear()
    }
end function

' Creates an object composed of keys generated from the results of running each element of collection thru iteratee. The order of grouped values is determined by the order they occur in collection. The corresponding value of each key is an array of elements responsible for generating the key. The iteratee is invoked with one argument: (value).
' @since 0.0.23
' @category Collection
' @param {Object} collection - The collection to iterate over.
' @param {Function|String} iteratee - The iteratee to transform keys.
' @returns {Object} Returns the composed aggregate object.
function rodash_groupBy(collection as Object, iteratee = Invalid as Dynamic) as Object
    if NOT (type(collection) = "roArray") then
        return CreateObject("roAssociativeArray")
    end if
    collection = rodash_clone(collection)
    acc = CreateObject("roAssociativeArray")
    if rodash_isFunction(iteratee) then
        for each value in collection
            key = rodash_toString(iteratee(value))
            if acc.doesExist(key)
                acc[key].push(value)
            else
                acc[key] = [
                    value
                ]
            end if
        end for
    else if (type(iteratee) = "String" OR type(iteratee) = "roString") then
        for each value in collection
            if (type(value) = "roAssociativeArray") AND value.doesExist(iteratee) then
                key = rodash_toString(value[iteratee])
                if acc.doesExist(key)
                    acc[key].push(value)
                else
                    acc[key] = [
                        value
                    ]
                end if
            end if
        end for
    end if
    return acc
end function

' Checks if value is greater than other.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - The value to compare.
' @param {Dynamic} other - The other value to compare.
' @returns {Boolean} - Returns `true` if value is greater than other, else `false`.
' @example
' rodash.gt(3, 1) ' => true
' rodash.gt(3, 3) ' => false
' rodash.gt(1, 3) ' => false
function rodash_gt(value as Dynamic, other as Dynamic)
    return value > other
end function

' Checks if value is greater than or equal to other.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - The value to compare.
' @param {Dynamic} other - The other value to compare.
' @returns {Boolean} - Returns `true` if value is greater than or equal to other, else `false`.
' @example
' rodash.gte(3, 1) ' => true
' rodash.gte(3, 3) ' => true
' rodash.gte(1, 3) ' => false
function rodash_gte(value as Dynamic, other as Dynamic)
    return value >= other
end function

' Checks if first level of the supplied AssociativeArray contains the Array of key strings.
' @since 0.0.21
' @category Object
' @param {Dynamic} aaValue - AssociativeArray to be checked
' @param {Array} keys - Array of key strings
' @returns {Boolean} - Returns `true` if first level of the supplied AssociativeArray contains the Array of key strings, else `false`.
' @example
' rodash.hasKeys({a: 1, b: 2, c: 3}, ["a", "b"]) ' => true
' rodash.hasKeys({a: 1, b: 2, c: 3}, ["a", "d"]) ' => false
' rodash.hasKeys({a: 1, b: 2, c: 3}, ["a", "b", "c"]) ' => true
' rodash.hasKeys([1,2,3], ["a", "b", "d"]) ' => false
function rodash_hasKeys(aaValue as Dynamic, keys as Dynamic) as Boolean
    if NOT (getInterface(aaValue, "ifAssociativeArray") <> Invalid) OR aaValue.isEmpty() OR NOT (type(keys) = "roArray") OR keys.isEmpty() then
        return false
    end if
    for each key in keys
        if NOT aaValue.doesExist(key) then
            return false
        end if
    end for
    return true
end function

' Gets the first element of array.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @returns {Dynamic} Returns the first element of array
' @example
' rodash.head([1, 2, 3]) // => 1
function rodash_head(array = CreateObject("roArray", 0, true) as Object) as Dynamic
    return array[0]
end function

' Checks if number is between start and up to, but not including, end. If end is not specified, it's set to start with start then set to 0.
' @since 0.0.21
' @category Number
' @param {Number} number - The number to check.
' @param {Number} [startPos=0] - The start of the range.
' @param {Number} [endPos=startPos] - The end of the range.
' @returns {Boolean} - Returns `true` if number is in the range, else `false`.
function rodash_inRange(number as dynamic, startPos = 0 as dynamic, endPos = invalid as dynamic)
    if ((type(endPos) = "<uninitialized>" OR endPos = Invalid)) then
        endPos = startPos
        startPos = 0
    end if
    if (startPos > endPos) then
        startPosTemp = startPos
        endPosTemp = endPos
        startPos = endPosTemp
        endPos = startPosTemp
    end if
    return (number >= startPos) AND (number < endPos)
end function

' Gets the index at which the first occurrence of value is found in array using SameValueZero for equality comparisons. If fromIndex is negative, it's used as the offset from the end of array.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to inspect
' @param {Dynamic} value - The value to search for
' @param {Integer} fromIndex - The index to search from
' @returns {Integer} Returns the index of the matched value, else -1
function rodash_indexOf(array = CreateObject("roArray", 0, true) as Object, value = Invalid, fromIndex = Invalid)
    if NOT (type(array) = "roArray") then
        return -1
    end if
    if (type(fromIndex) = "<uninitialized>" OR fromIndex = Invalid) then
        fromIndex = 0
    end if
    for index = fromIndex to array.count() - 1
        item = array[index]
        if rodash_isEqual(item, value) then
            return index
        end if
    end for
    return -1
end function

' Gets all but the last element of array.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @returns {Array} Returns the slice of array
function rodash_initial(array = CreateObject("roArray", 0, true) as Object)
    if NOT (type(array) = "roArray") then
        return []
    end if
    return rodash_slice(array, 0, array.count() - 1)
end function

' @ignore
' Attempts to convert the supplied value to a string.
' @since 0.0.21
' @category Internal
' @param {Dynamic} value - The value to convert.
' @returns {String} Results of the conversion.
function rodash_internal_aaToString(aa as Object) as String
    description = "{"
    for each key in aa
        description += key + ": " + rodash_toString(aa[key]) + ", "
    end for
    description = description.left(description.len() - 2) + "}"
    return description
end function

' @ignore
' Attempts to convert the supplied value to a string.
' @since 0.0.21
' @category Internal
' @param {Dynamic} value The value to convert.
' @returns {String} Results of the conversion.
function rodash_internal_arrayToString(array as Object) as String
    description = "["
    for each item in array
        description += rodash_toString(item) + ", "
    end for
    description = description.left(description.len() - 2) + "]"
    return description
end function

' @ignore
' The base implementation of `forEach`.
' @since 0.0.21
' @category Internal
' @param {Array|Object} - collection The collection to iterate over
' @param {Function} iteratee The function invoked per iteration
' @param {String} direction - the direction to traverse the collection
' @param {String} funcValueRule - Filters functions from collection. `allow`, `omit`, `only`.
' @returns {Array|Object} Returns `collection`
function rodash_internal_baseForEach(collection = Invalid as Dynamic, iteratee = Invalid as Dynamic, direction = "left", funcValueRule = "allow" as String)
    if (type(collection) = "<uninitialized>" OR collection = Invalid) OR collection.isEmpty() then
        return Invalid
    end if
    isRight = direction = "right"
    if (type(collection) = "roAssociativeArray") then
        keys = collection.keys()
        if isRight then
            keys.reverse()
        end if
        for each key in keys
            item = collection[key]
            if rodash_isFunction(iteratee) then
                valueIsFunction = rodash_isFunction(item)
                allowValue = false
                if valueIsFunction AND NOT rodash_isEqual(funcValueRule, "omit")
                    allowValue = true
                else if NOT valueIsFunction AND NOT rodash_isEqual(funcValueRule, "only")
                    allowValue = true
                end if
                if allowValue then
                    iteratee(item, key)
                end if
            end if
        end for
    else
        if isRight then
            collection.reverse()
        end if
        for each item in collection
            if rodash_isFunction(iteratee) then
                iteratee(item)
            end if
        end for
        if isRight then
            collection.reverse()
        end if
    end if
    return collection
end function

' @ignore
' Attempts to convert the supplied value to a string.
' @since 0.0.21
' @category Internal
' @param {Dynamic} value The value to convert.
' @returns {String} Results of the conversion.
function rodash_internal_booleanToString(bool as Boolean) as String
    if bool then
        return "true"
    end if
    return "false"
end function

' @ignore
' Checks if the supplied values can be compared in a if statement.
' @since 0.0.21
' @category Internal
' @param {Dynamic} valueOne - First value
' @param {Dynamic} valueTwo - Second value
' @returns {Boolean} True if the values can be compared in a if statement
function rodash_internal_canBeCompared(valueOne as Dynamic, valueTwo as Dynamic) as Boolean
    valueOneType = type(valueOne)
    valueTwoType = type(valueTwo)
    if (valueOneType = "String" OR valueOneType = "roString") then
        if (valueTwoType = "String" OR valueTwoType = "roString") then
            return true
        end if
    else if (valueOneType = "Integer" OR valueOneType = "roInt" OR valueOneType = "roInteger" OR valueOneType = "LongInteger" OR valueOneType = "Float" OR valueOneType = "roFloat" OR valueOneType = "Double" OR valueOneType = "roDouble" OR valueOneType = "roIntrinsicDouble") then
        if (valueTwoType = "Integer" OR valueTwoType = "roInt" OR valueTwoType = "roInteger" OR valueTwoType = "LongInteger" OR valueTwoType = "Float" OR valueTwoType = "roFloat" OR valueTwoType = "Double" OR valueTwoType = "roDouble" OR valueTwoType = "roIntrinsicDouble") then
            return true
        end if
    else if (valueOneType = "Boolean" OR valueOneType = "roBoolean") then
        if (valueTwoType = "Boolean" OR valueTwoType = "roBoolean") then
            return true
        end if
    else if (valueOneType = "<uninitialized>" OR valueOne = Invalid) then
        if (valueTwoType = "<uninitialized>" OR valueTwo = Invalid) then
            return true
        end if
    end if
    return false
end function

' @ignore
function rodash_internal_getConstants()
    return {
        BrightScriptErrorCodes: {
            ' runtime errors
            ERR_OKAY: &hFF
            ERR_NORMAL_END: &hFC ' normal, but terminate execution.  END, shell "exit", window closed, etc.
            ERR_VALUE_RETURN: &hE2 ' return executed, and a value returned on the stack
            ERR_INTERNAL: &hFE ' A condition that shouldn't occur did
            ERR_UNDEFINED_OPCD: &hFD ' A opcode that we don't handle
            ERR_UNDEFINED_OP: &hFB ' An expression operator that we don't handle
            ERR_MISSING_PARN: &hFA
            ERR_STACK_UNDER: &hF9 ' nothing on stack to pop
            ERR_BREAK: &hF8 ' scriptBreak() called
            ERR_STOP: &hF7 ' stop statement executed
            ERR_RO0: &hF6 ' bscNewComponent failed because object class not found
            ERR_RO1: &hF5 ' ro function call does not have the right number of parameters
            ERR_RO2: &hF4 ' member function not found in object or interface
            ERR_RO3: &hF3 ' Interface not a member of object
            ERR_TOO_MANY_PARAM: &hF2 ' Too many function parameters to handle
            ERR_WRONG_NUM_PARAM: &hF1 ' Incorect number of function parameters
            ERR_RVIG: &hF0 ' Function returns a value, but is ignored
            ERR_NOTPRINTABLE: &hEF ' Non Printable value
            ERR_NOTWAITABLE: &hEE ' Tried to Wait on a function that does not have MessagePort interface
            ERR_MUST_BE_STATIC: &hED ' interface calls from type rotINTERFACE must by static
            ERR_RO4: &hEC ' . operator used on a variable that does not contain a legal object or interface reference
            ERR_NOTYPEOP: &hEB ' operation on two typless operands attempted
            ERR_USE_OF_UNINIT_VAR: &hE9 ' illegal use of uninited var
            ERR_TM2: &hE8 ' non-numeric index to array
            ERR_ARRAYNOTDIMMED: &hE7
            ERR_USE_OF_UNINIT_BRSUBREF: &hE6 ' used a reference to SUB that is not initilized
            ERR_MUST_HAVE_RETURN: &hE5
            ERR_INVALID_LVALUE: &hE4 ' invalid left side of expression
            ERR_INVALID_NUM_ARRAY_IDX: &hE3 ' invalid number of array indexes
            ERR_UNICODE_NOT_SUPPORTED: &hE1
            ERR_NOTFUNOPABLE: &hE0
            ERR_STACK_OVERFLOW: &hDF
            ERR_THROWN_EXCEPTION_ON_STACK: &hDE '(Internal use only)
            ERR_SYNTAX: &h02
            ERR_DIV_ZERO: &h14
            ERR_MISSING_LN: &h0E
            ERR_OUTOFMEM: &h0C
            ERR_STRINGTOLONG: &h1C
            ERR_TM: &h18 ' Type Mismatch (string / numeric operation mismatch)
            ERR_OS: &h1A ' out of string space
            ERR_RG: &h04 ' Return without Gosub
            ERR_NF: &h00 ' Next without For
            ERR_FC: &h08 ' Invalid parameter passed to function/array (e.g neg matrix dim or squr root)
            ERR_DD: &h12 ' Attempted to redimension an array
            ERR_BS: &h10 ' Array subscript out of bounds
            ERR_OD: &h06 ' Out of Data (READ)
            ERR_CN: &h20 ' Continue Not Allowed
            ERR_BITSHIFT_BAD: &h1E ' Invalid Bitwise Shift
            ERR_EXECUTION_TIMEOUT: &h23 ' Timeout on critical thread
            ERR_CONSTANT_OVERFLOW: &h22 ' Constant Out Of Range
            ERR_FORMAT_SPECIFIER: &h24 ' Invalid Format Specifier
            ERR_BAD_THROW: &h26 ' Invalid argument to Throw
            ERR_USER: &h28 ' User-specified exception
            ' compiler errors
            ERR_NW: &hBF ' EndWhile with no While
            ERR_MISSING_ENDWHILE: &hBE ' While Statement is missing a matching EndWhile
            ERR_MISSING_ENDIF: &hBC ' end of code reached without finding ENDIF
            ERR_NOLN: &hBB ' no line number found
            ERR_LNSEQ: &hBA ' Line number sequence error
            ERR_LOADFILE: &hB9 ' Error loading a file
            ERR_NOMATCH: &hB8 ' "Match" statement did not match
            ERR_UNEXPECTED_EOF: &hB7 ' End of string being compiled encountered when not expected (missing end of block usually)
            ERR_FOR_NEXT_MISMATCH: &hB6 ' Variable on a NEXT does not match that for the FOR
            ERR_NO_BLOCK_END: &hB5
            ERR_LABELTWICE: &hB4 ' Label defined more than once
            ERR_UNTERMED_STRING: &hB3 ' litteral string does not have ending quote
            ERR_FUN_NOT_EXPECTED: &hB2
            ERR_TOO_MANY_CONST: &hB1
            ERR_TOO_MANY_VAR: &hB0
            ERR_EXIT_WHILE_NOT_IN_WHILE: &hAF
            ERR_INTERNAL_LIMIT_EXCEDED: &hAE
            ERR_SUB_DEFINED_TWICE: &hAD
            ERR_NOMAIN: &hAC
            ERR_FOREACH_INDEX_TM: &hAB
            ERR_RET_CANNOT_HAVE_VALUE: &hAA
            ERR_RET_MUST_HAVE_VALUE: &hA9
            ERR_FUN_MUST_HAVE_RET_TYPE: &hA8
            ERR_INVALID_TYPE: &hA7
            ERR_NOLONGER: &hA6 ' no longer supported
            ERR_EXIT_FOR_NOT_IN_FOR: &hA5
            ERR_MISSING_INITILIZER: &hA4
            ERR_IF_TOO_LARGE: &hA3
            ERR_RO_NOT_FOUND: &hA2
            ERR_TOO_MANY_LABELS: &hA1
            ERR_VAR_CANNOT_BE_SUBNAME: &hA0
            ERR_INVALID_CONST_NAME: &h9F
            ERR_CONST_FOLDING: &h9E
            ERR_BUILTIN_FUNCTION: &h9D
            ERR_FUNCTION_NOT_IN_NAMESPACE: &h91
            ERR_EVAL_UNSUPPORTED: &h90
            ERR_LABEL_INSIDE_TRY: &h8F
        }
        MAX_INT: 2147483647
        MIN_INT: -2147483648
    }
end function

' @ignore
function rodash_internal_getDateObject() as object
    dateObj = CreateObject("roDateTime")
    utc = dateObj
    dateObj.toLocalTime()
    local = dateObj
    return {
        "utc": utc
        "local": local
    }
end function

' @ignore
' Checks if the supplied value allows for key field access
' @since 0.0.21
' @category Internal
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_internal_isKeyedValueType(value as Dynamic) as Boolean
    return getInterface(value, "ifAssociativeArray") <> Invalid
end function

' @ignore
' Attempts to converts a nodes top level fields to an AssociativeArray.
' @since 0.0.21
' @category Internal
' @param {Dynamic} value - The variable to be converted.
' @param {Boolean} removeId - If set to true the nodes ID will also be stripped.
' @param {Object} removeFields - List of keys that need to be removed from the node.
' @returns {Dynamic} Results of the conversion.
function rodash_internal_nodeToAA(value as Object, removeId = false as Boolean, removeFields = Invalid as Dynamic) as Object
    if rodash_isNode(value) then
        fields = value.getFields()
        fields.delete("change")
        fields.delete("focusable")
        fields.delete("focusedChild")
        fields.delete("ready")
        if removeId then
            fields.delete("id")
        end if
        'Looping through any additional fields if passed.
        if (type(removeFields) = "roArray" AND NOT removeFields.isEmpty()) then
            for each field in removeFields
                fields.delete(field)
            end for
        end if
        return fields
    else if (type(value) = "roAssociativeArray") then
        return value
    end if
    return {}
end function

' @ignore
' Attempts to convert the supplied value to a string.
' @since 0.0.21
' @category Internal
' @param {Dynamic} value The value to convert.
' @returns {String} Results of the conversion.
function rodash_internal_nodeToString(node as Object) as String
    if NOT rodash_isNode(node) then
        return ""
    end if
    description = node.subtype()
    if node.isSubtype("Group") then
        ' accessing properties from anywhere but the render thread is too expensive to include here
        id = node.id
        if id <> "" then
            description += " (" + id + ")" + rodash_internal_aaToString(rodash_internal_nodeToAA(node))
        end if
    end if
    return description
end function

' @ignore
' Attempts to convert the supplied value to a string.
' @param {Dynamic} value The value to convert.
' @returns {String} Results of the conversion.
function rodash_internal_numberToString(value as Dynamic) as String
    return value.toStr()
end function

' @ignore
function rodash_internal_orderByCompare(item1 as Object, item2 as Object, keys as Object, orders as Object) as Boolean
    ' Iterate through the keys and corresponding orders
    for i = 0 to keys.Count() - 1
        key = keys[i]
        order = orders[i]
        if order = invalid then
            order = "asc"
        end if
        value1 = item1[key]
        value2 = item2[key]
        ' Compare the values based on the current key
        if value1 <> value2
            if order = "asc"
                return value1 > value2
            else if order = "desc"
                return value1 < value2
            end if
        end if
    end for
    ' If all values are equal, maintain original order
    return false
end function

' @ignore
function rodash_internal_sanitizeKeyPath(value = "" as String)
    regex = createObject("roRegex", "\[(.*?)\]", "i")
    matches = regex.matchAll(value)
    if (type(matches) <> "<uninitialized>" AND matches <> Invalid) then
        for each match in matches
            if (type(match) <> "<uninitialized>" AND match <> Invalid) then
                value = value.replace(match[0], "." + match[1])
            end if
        end for
    end if
    return value
end function

' Creates an array of unique values that are included in all given arrays using SameValueZero for equality comparisons. The order and references of result values are determined by the first array.
' @since 0.0.21
' @category Array
' @param {Array} mainArray - The main array to inspect
' @param {Array} inspect - The array to find matches
' @returns {Array} Returns the new array of intersecting values
function rodash_intersection(mainArray = CreateObject("roArray", 0, true) as Object, inspectArray = CreateObject("roArray", 0, true) as Object) as Object
    return rodash_intersectionBy(mainArray, inspectArray)
end function

' This method is like rodash.intersection except that it accepts iteratee which is invoked for each element of each arrays to generate the criterion by which they're compared. The order and references of result values are determined by the first array. The iteratee is invoked with one argument:(value).
' @since 0.0.21
' @category Array
' @param {Array} mainArray - The main array to inspect
' @param {Array} inspect - The array to find matches
' @param {Dynamic} iteratee - The iteratee invoked per element
' @returns {Array} Returns the new array of intersecting values
function rodash_intersectionBy(mainArray = CreateObject("roArray", 0, true) as Object, inspectArray = CreateObject("roArray", 0, true) as Object, iteratee = Invalid) as Object
    intersectArray = CreateObject("roArray", 0, true)
    mainArray = rodash_clone(mainArray)
    inspectArray = rodash_clone(inspectArray)
    if (type(iteratee) = "<uninitialized>" OR iteratee = Invalid) then
        if (type(mainArray) = "roArray" AND NOT mainArray.isEmpty()) then
            for each item in mainArray
                if NOT rodash_isEqual(rodash_indexOf(inspectArray, item), -1) then
                    intersectArray.push(item)
                end if
            end for
        end if
    else if rodash_isFunction(iteratee) then
        for i = 0 to inspectArray.count() - 1
            inspectArray[i] = iteratee(inspectArray[i])
        end for
        for each item in mainArray
            if NOT rodash_isEqual(rodash_indexOf(inspectArray, iteratee(item)), -1) then
                intersectArray.push(item)
            end if
        end for
    else if (type(iteratee) = "String" OR type(iteratee) = "roString") then
        for each item in mainArray
            findKey = item[iteratee]
            if (type(findKey) <> "<uninitialized>" AND findKey <> Invalid) then
                matchValue = CreateObject("roAssociativeArray")
                matchValue[iteratee] = findKey
                if NOT rodash_isEqual(rodash_findIndex(inspectArray, matchValue), -1) then
                    intersectArray.push(item)
                end if
            end if
        end for
    end if
    return intersectArray
end function

' This method is like rodash.intersection except that it accepts comparator which is invoked to compare elements of arrays. The order and references of result values are determined by the first array. The comparator is invoked with two arguments: (arrVal, othVal).
' @since 0.0.21
' @category Array
' @param {Array} mainArray - The main array to inspect
' @param {Array} inspect - The array to find matches
' @param {Dynamic} comparator - The comparator invoked per element
' @returns {Array} Returns the new array of intersecting values
function rodash_intersectionWith(mainArray = CreateObject("roArray", 0, true) as Object, inspectArray = CreateObject("roArray", 0, true) as Object, comparator = Invalid) as Object
    if NOT rodash_isFunction(comparator) then
        return []
    end if
    return rodash_intersectionBy(mainArray, inspectArray, comparator)
end function

' Creates an object composed of the inverted keys and values of `object`.
' If `object` contains duplicate values, subsequent values overwrite property assignments of previous values.
' As AssocArrays are sorted, the order of the aa keys is not preserved.
' @since 0.0.22
' @category Object
' @param {Object} object The object to invert.
' @returns {Object} Returns the new inverted object.
' @example
' *
' const object = { 'a': 1, 'b': 2, 'c': 1 }
' rodash.invert(object)
' // { '1': 'c', '2': 'b' }
function rodash_invert(originalAA as Object) as Dynamic
    if not (type(originalAA) = "roAssociativeArray") then
        return invalid
    end if
    ' Initialize an empty associative array to hold the inverted key-value pairs
    invertedAA = CreateObject("roAssociativeArray")
    ' Iterate over each key-value pair in the original associative array
    for each key in originalAA.keys()
        ' Assign the value as the new key and the key as the new value in the inverted array
        invertedAA[rodash_toString(originalAA[rodash_toString(key)])] = key
    end for
    ' Return the newly created inverted associative array
    return invertedAA
end function

' Checks if the supplied value is a valid AssociativeArray type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isAA({}) // => true
' rodash.isAA([]) // => false
function rodash_isAA(value as Dynamic) as Boolean
    return type(value) = "roAssociativeArray"
end function

' Checks if the supplied value is a roAppMemoryMonitorEvent type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isAppMemoryMonitorEvent(value as Dynamic) as Boolean
    return type(value) = "roAppMemoryNotificationEvent"
end function

' Checks if the supplied value is a valid Array type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isArray([]) // => true
' rodash.isArray({}) // => false
' rodash.isArray("") // => false
function rodash_isArray(value as Dynamic) as Boolean
    return type(value) = "roArray"
end function

' Checks if value is array-like. A value is considered array-like if it is an array, a string, or an node with children.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isArrayLike([]) // => true
' rodash.isArrayLike({}) // => false
function rodash_isArrayLike(value as Dynamic) as Boolean
    return (type(value) = "roArray") OR (type(value) = "String" OR type(value) = "roString") OR rodash_isNodeWithChildren(value)
end function

' Checks if the supplied value is a valid Boolean type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isBoolean(true) // => true
' rodash.isBoolean(false) // => true
' rodash.isBoolean(1) // => false
' rodash.isBoolean("true") // => false
function rodash_isBoolean(value as Dynamic) as Boolean
    return type(value) = "Boolean" OR type(value) = "roBoolean"
end function

' Checks if the supplied value is a valid ByteArray type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isByteArray(value as Dynamic)
    return type(value) = "roByteArray"
end function

' Alias to isDate function
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isDate(value as Dynamic) as Boolean
    return (type(value) = "roDateTime")
end function

' Checks if the supplied value is a valid date time type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isDateTime(value as Dynamic) as Boolean
    return type(value) = "roDateTime"
end function

' Checks if the supplied value is a roDeviceInfo type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isDeviceInfoEvent(value as Dynamic) as Boolean
    return type(value) = "roDeviceInfoEvent"
end function

' Checks if the supplied value is a valid Double type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isDouble(1) // => false
' rodash.isDouble(1.0#) // => true
' rodash.isDouble(1.0!) // => false
function rodash_isDouble(value as Dynamic) as Boolean
    return type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble"
end function

' Alias to isNode function
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @param {String} subType An optional subType parameter to further refine the check
' @returns {Boolean} Results of the check
function rodash_isElement(value as Dynamic, subType = "" as String) as Boolean
    return rodash_isNode(value, subtype)
end function

' Checks if a value is empty.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isEmpty("") // => true
' rodash.isEmpty([]) // => true
' rodash.isEmpty({}) // => true
' rodash.isEmpty(0) // => true
' rodash.isEmpty(false) // => true
' rodash.isEmpty(invalid) // => true
' rodash.isEmpty("Hello") // => false
function rodash_isEmpty(value as Dynamic)
    if (type(value) = "<uninitialized>" OR value = Invalid) OR (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble") OR (type(value) = "Boolean" OR type(value) = "roBoolean") then
        return true
    else
        return value.isEmpty()
    end if
    return true
end function

' Checks if the supplied value is a valid String type and is not empty
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isEmptyString("") // => true
' rodash.isEmptyString(" ") // => false
' rodash.isEmptyString("Hello") // => false
function rodash_isEmptyString(value as Dynamic) as Boolean
    return (type(value) = "String" OR type(value) = "roString") AND value.isEmpty()
end function

' Checks if the supplied values are the same.
' By default, when comparing arrays and associative arrays the function will compare the values on the elements. If the strict parameter is set to true, the function will compare the references of the elements.
' @since 0.0.21
' @category Lang
' @param {Dynamic} valueOne - First value.
' @param {Dynamic} valueTwo - Second value.
' @returns {Boolean} True if the values are the same and false if not or if any of the values are a type that could not be compared.
' @example
' rodash.isEqual(1, 1) // => true
' rodash.isEqual(1, 2) // => false
' rodash.isEqual([], []) // => true
' rodash.isEqual({}, {}) // => true
' rodash.isEqual({a: 1}, {a: 1}) // => true
' rodash.isEqual({a: 1}, {a: 2}) // => false
' rodash.isEqual("Hello", "Hello") // => true
' rodash.isEqual("Hello", "World") // => false
function rodash_isEqual(valueOne as Dynamic, valueTwo as Dynamic, strict = false as Boolean) as Boolean
    ' If the first argument is true we don't need to check the follwing conditionals
    if rodash_internal_canBeCompared(valueOne, valueTwo) then
        return (valueOne = valueTwo)
    else if rodash_isNode(valueOne) then
        if rodash_isNode(valueTwo) then
            return valueOne.isSameNode(valueTwo)
        end if
    else if (type(valueOne) = "roAssociativeArray") AND (type(valueTwo) = "roAssociativeArray") then
        if strict then
            key = ("internal_key_" + bslib_toString(rodash_random(1000000, 2000000)))
            valueOne.addReplace(key, "true")
            isSame = false
            if valueTwo.doesExist(key) then
                isSame = true
            end if
            valueOne.delete(key)
            return isSame
        end if
        if (rodash_clone(valueOne.keys()).join(",")) = (rodash_clone(valueTwo.keys()).join(",")) then
            return (formatJson(valueOne) = formatJson(valueTwo))
        end if
    else if (type(valueOne) = "roArray") then
        if strict then
            key = ("internal_key_" + bslib_toString(rodash_random(1000000, 2000000)))
            valueOne.push(key)
            isSame = rodash_isEqual((valueTwo[valueTwo.count() - 1]), key)
            valueOne.pop()
            return isSame
        end if
        if (type(valueTwo) = "roArray") AND (valueOne.count() = valueTwo.count()) then
            return (formatJson(valueOne) = formatJson(valueTwo))
        end if
    end if
    return false
end function

' Checks if the supplied values are the same.
' @since 0.0.21
' @category Lang
' @param {Dynamic} valueOne - First value.
' @param {Dynamic} valueTwo - Second value.
' @returns {Boolean} True if the values are the same and false if not or if any of the values are a type that could not be compared.
function rodash_isEqualWith(valueOne as Dynamic, valueTwo as Dynamic, customizer = Invalid) as Boolean
    ' If the first argument is true we don't need to check the follwing conditionals
    ' TODO: revisit this agressively
    if rodash_internal_canBeCompared(valueOne, valueTwo) then
        return customizer(valueOne, valueTwo)
    else if rodash_isNode(valueOne) then
        if rodash_isNode(valueTwo) then
            valueOne = valueOne.getFields()
            valueOne.delete("change")
            valueOne.delete("focusable")
            valueOne.delete("focusedChild")
            valueOne.delete("ready")
            valueTwo = valueTwo.getFields()
            valueTwo.delete("change")
            valueTwo.delete("focusable")
            valueTwo.delete("focusedChild")
            valueTwo.delete("ready")
            return rodash_isEqualWith(valueOne, valueTwo, customizer)
        end if
    else if (type(valueOne) = "roAssociativeArray") then
        if (type(valueTwo) = "roAssociativeArray") AND (valueOne.keys().count() = valueTwo.keys().count()) then
            keys = valueOne.keys()
            for each key in keys
                if customizer(valueOne[key], valueTwo[key]) then
                    return true
                end if
            end for
        end if
    else if (type(valueOne) = "roArray") then
        if (type(valueTwo) = "roArray") AND (valueOne.count() = valueTwo.count()) then
            for i = 0 to valueOne.count() - 1
                if customizer(valueOne[i], valueTwo[i]) then
                    return true
                end if
            end for
        end if
    end if
    return false
end function

' Assesses the passed object to determine if it is an Error Object.
' TODO: MORE SUPPORT - TRY/CATCH?
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - the object to assess
' @returns {Boolean} True if the object represents and error.
function rodash_isError(value as Dynamic) as Boolean
    if (type(value) = "roAssociativeArray") then
        if ((type(value.status) = "String" OR type(value.status) = "roString") AND NOT value.status.isEmpty()) AND (value.status.Instr("error") > -1) then
            return true
        end if
        errorCodes = rodash_internal_getConstants().BrightScriptErrorCodes
        if rodash_hasKeys(value, [
            "number"
            "message"
            "exception"
        ]) then
            for each errorCode in errorCodes
                if value.number = errorCode then
                    return true
                end if
            end for
        end if
    end if
    return false
end function

' Checks if `value` is a finite primitive number.
' @since 0.0.21
' @category Lang
function rodash_isFinite(value as dynamic) as boolean
    if NOT (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble") then
        return false
    end if
    constants = rodash_internal_getConstants()
    if (value > constants.max_int) OR (value < constants.min_int) then
        return false
    end if
    return true
end function

' Checks if the supplied value is a valid Float type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isFloat(1) // => false
' rodash.isFloat(1.0!) // => true
' rodash.isFloat(1.0#) // => false
function rodash_isFloat(value as Dynamic) as Boolean
    return type(value) = "Float" OR type(value) = "roFloat"
end function

' Checks if the supplied value is a valid Function type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isFunction(value as Dynamic) as Boolean
    valueType = type(value)
    return (valueType = "roFunction") OR (valueType = "Function")
end function

' Checks if the supplied value is a roInputEvent type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isInputEvent(value as Dynamic) as Boolean
    return type(value) = "roInputEvent"
end function

' Checks if the supplied value is a valid Integer type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isInteger(value as Dynamic) as Boolean
    return type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger"
end function

' Checks if the supplied value is Invalid
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isInvalid(Invalid) // => true
' rodash.isInvalid(undefined) // => true
' rodash.isInvalid("") // => false
function rodash_isInvalid(value as Dynamic) as Boolean
    return type(value) = "<uninitialized>" OR value = Invalid
end function

' Checks if value is a valid array-like length
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isLength(value as Dynamic) as Boolean
    if (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger") AND rodash_isFinite(value) AND (value >= 0) then
        return true
    end if
    return false
end function

' Alias to isArray function
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
' @example
' rodash.isMap([]) // => true
' rodash.isMap({}) // => false
function rodash_isMap(value as Dynamic) as Boolean
    return (type(value) = "roArray")
end function

' Checks if the supplied value is a roMessagePort type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isMessagePort(value as Dynamic) as Boolean
    return type(value) = "roMessagePort"
end function

' Method determines whether the passed value is NaN and its type is a valid number
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNaN(value as Dynamic) as Boolean
    return NOT (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble")
end function

' Checks if the supplied value is a valid Node type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @param {String} subType An optional subType parameter to further refine the check
' @returns {Boolean} Results of the check
function rodash_isNode(value as Dynamic, subType = "" as String) as Boolean
    if type(value) <> "roSGNode" then
        return false
    end if
    if subType <> "" then
        return value.isSubtype(subType)
    end if
    return true
end function

' Checks if the supplied value is a valid roSGNodeEvent type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNodeEvent(value as Dynamic) as Boolean
    return type(value) = "roSGNodeEvent"
end function

' Checks if the supplied value is a valid roUrlEvent type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value - The variable to be checked
' @param {String} subType - An optional subType parameter to further refine the check
' @returns Results of the check
function rodash_isNodeWithChildren(value as Dynamic, subType = "" as String) as Boolean
    if type(value) <> "roSGNode" then
        return false
    end if
    if subType <> "" then
        return value.isSubtype(subType) AND value.getChildCount() > 0
    end if
    return value.getChildCount() > 0
end function

' Checks if the supplied value is a valid and populated AssociativeArray type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNonEmptyAA(value as Dynamic)
    return type(value) = "roAssociativeArray" AND value.keys().count() > 0
end function

' Checks if the supplied value is a valid Array type and not empty
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNonEmptyArray(value as Dynamic) as Boolean
    return type(value) = "roArray" AND NOT value.isEmpty()
end function

' Checks if the supplied value is a valid String type and is not empty
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNonEmptyString(value as Dynamic) as Boolean
    return (type(value) = "String" OR type(value) = "roString") AND NOT value.isEmpty()
end function

' Checks if the supplied value is not Invalid or uninitialized
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNotInvalid(value as Dynamic) as Boolean
    return type(value) <> "<uninitialized>" AND value <> Invalid
end function

' Alias to isInvalid function
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNull(value as Dynamic) as Boolean
    return NOT (type(value) <> "<uninitialized>" AND value <> Invalid)
end function

' Checks if the supplied value is a valid number type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isNumber(value as Dynamic) as Boolean
    return type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble"
end function

' Checks if the supplied value is a valid String type
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isString(value as Dynamic)
    return type(value) = "String" OR type(value) = "roString"
end function

' Checks if the supplied value is a valid roUrlEvent type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isUrlEvent(value as Dynamic) as Boolean
    return type(value) = "roUrlEvent"
end function

' Checks if the supplied value is a valid url transfer type
' @since 0.0.26
' @category Lang
' @param {Dynamic} value The variable to be checked
' @returns {Boolean} Results of the check
function rodash_isUrlTransfer(value as Dynamic) as Boolean
    return type(value) = "roUrlTransfer"
end function

' Converts all elements in array into a string separated by separator.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to convert
' @param {String} separator - The element separator
' @returns {Array} Returns the joined string
function rodash_join(array = CreateObject("roArray", 0, true) as Object, separator = "" as String)
    return rodash_clone(array).join(separator)
end function

' Converts a string to kebab case.
' @since 0.0.21
' @category String
function rodash_kebabCase(value = "" as string)
    value = value.replace("-", " ").replace("_", " ")
    value = value.trim()
    valueArray = value.split(" ")
    return lcase((rodash_clone(valueArray).join("-")))
end function

' Creates an object composed of keys generated from the results of running each element of collection thru iteratee. The corresponding value of each key is the last element responsible for generating the key. The iteratee is invoked with one argument: (value).
' @since 0.0.24
' @category Collection
' @param {Dynamic} collection - The collection to sample
' @param {String} key - The iteratee to transform keys.
' @returns {Dynamic} - Returns the composed aggregate object.
function rodash_keyBy(collection = invalid as dynamic, key = "" as string) as object
    returnObject = CreateObject("roAssociativeArray")
    if not (type(collection) = "roArray") then
        return returnObject
    end if
    for each item in collection
        if (type(item) = "roAssociativeArray") and item.doesExist(key) then
            newKey = rodash_toString(item[key])
            returnObject[newKey] = item
        end if
    end for
    return returnObject
end function

' Gets the last element of array.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to query
' @returns {Dynamic} Returns the last element of array
function rodash_last(array = CreateObject("roArray", 0, true)) as Dynamic
    return array[array.count() - 1]
end function

' This method is like rodash.indexOf except that it iterates over elements of array from right to left.
' @since 0.0.23
' @category Array
' @param {Array} array - The array to query
' @param {Dynamic} value - The value to search for
' @param {Integer} fromIndex - The index to search from
' @returns {Dynamic} Returns the index of the matched value, else -1
function rodash_lastIndexOf(array = CreateObject("roArray", 0, true) as Object, value = Invalid as Dynamic, fromIndex = Invalid as Dynamic) as Dynamic
    if NOT (type(array) = "roArray") then
        return -1
    end if
    if (type(fromIndex) = "<uninitialized>" OR fromIndex = Invalid) then
        fromIndex = array.count() - 1
    else if fromIndex < 0 then
        fromIndex = array.count() + fromIndex
    end if
    ' Ensure fromIndex is within valid bounds
    fromIndex = ((rodash_maxBy([
        0
        rodash_min([
            array.count() - 1
            fromIndex
        ])
    ])))
    for i = fromIndex to 0 step -1
        if rodash_isEqual(array[i], value) then
            return i
        end if
    end for
    return -1
end function

' Converts a string to lower case.
' @since 0.0.21
' @category String
function rodash_lowerCase(value = "" as string)
    value = value.replace("-", " ").replace("_", " ")
    value = value.trim()
    valueArray = value.split(" ")
    return lcase((rodash_clone(valueArray).join(" ")))
end function

' Converts the first character of string to lower case.
' @since 0.0.21
' @category String
function rodash_lowerFirst(value = "" as string)
    value = value.trim()
    valueArray = value.split("")
    valueArray[0] = lcase(valueArray[0])
    return (rodash_clone(valueArray).join(""))
end function

' Checks if value is less than other.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - The value to compare.
' @param {Dynamic} other - The other value to compare.
' @returns {Boolean} - Returns `true` if the value is less than other, else `false`.
function rodash_lt(value as dynamic, other as dynamic)
    return value < other
end function

' Checks if value is less than or equal to other.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value - The value to compare.
' @param {Dynamic} other - The other value to compare.
' @returns {Boolean} - Returns `true` if the value is less than or equal to other, else `false`.
function rodash_lte(value as dynamic, other as dynamic)
    return value <= other
end function

' Creates an array of values by running each element in collection thru iteratee. The iteratee is invoked with three arguments:(value, index|key, collection)
' @since 0.0.21
' @category Collection
' @param {Dynamic} collection - The collection to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @returns {Array} Returns the new mapped array
' @example
' rodash.map([4, 8], rodash.square) // => [16, 64]
function rodash_map(collection = CreateObject("roAssociativeArray") as Dynamic, iteratee = Invalid as Dynamic)
    returnArray = CreateObject("roArray", 0, true)
    collectionToProcess = CreateObject("roArray", 0, true)
    if (type(collection) = "String" OR type(collection) = "roString") then
        collectionToProcess.append(collection.split(""))
    else if (type(collection) = "roAssociativeArray") then
        for each key in collection.keys()
            collectionToProcess.push(collection[key])
        end for
    else if (type(collection) = "roArray") then
        collectionToProcess.append(collection)
    end if
    for each item in collectionToProcess
        if (type(iteratee) = "String" OR type(iteratee) = "roString") then
            if (type(item) = "roAssociativeArray") then
                returnArray.push(item[iteratee])
            end if
        else if rodash_isFunction(iteratee) then
            returnArray.push(iteratee(item))
        else
            returnArray.push(item)
        end if
    end for
    return returnArray
end function

' Computes the maximum value of array. If array is empty or falsey, invalid is returned.
' @since 0.0.21
' @category Math
' @param {Array} array - The array to iterate over
' @returns {Dynamic} Returns the maximum value
' @example
' rodash.max([4, 2, 8, 6]) // => 8
function rodash_max(array = CreateObject("roArray", 0, true) as Object) as Dynamic
    return rodash_maxBy(array)
end function

' Computes the maximum value of array. If array is empty or falsey, invalid is returned.
' @since 0.0.21
' @category Math
' @param {Array} array - The array to iterate over
' @returns {Dynamic} Returns the maximum value
function rodash_maxBy(array = CreateObject("roArray", 0, true) as Object, iteratee = Invalid) as Dynamic
    if rodash_isEmpty(array) then
        return Invalid
    end if
    maxValue = Invalid
    if (type(iteratee) = "<uninitialized>" OR iteratee = Invalid) then
        maxValue = rodash_internal_getConstants().min_int
        for each value in array
            if (value > maxValue) then
                maxValue = value
            end if
        end for
    else if rodash_isFunction(iteratee) AND (type(array[0]) = "roAssociativeArray") then
        maxValue = array[0]
        for each value in array
            if (iteratee(value) > iteratee(maxValue)) then
                maxValue = value
            end if
        end for
    else if (type(iteratee) = "String" OR type(iteratee) = "roString") AND (type(array[0]) = "roAssociativeArray") then
        maxValue = array[0]
        for each value in array
            if (value[iteratee] > maxValue[iteratee]) then
                maxValue = value
            end if
        end for
    end if
    return maxValue
end function

' Computes the mean of the values in array.
' @since 0.0.21
' @category Math
' @param {Array} array - The array to iterate over
' @returns {Dynamic} Returns the mean value
' @example
' rodash.mean([4, 2, 8, 6]) // => 5
function rodash_mean(array)
    return rodash_meanBy(array)
end function

' This method is like `rodash.mean` except that it accepts `iteratee` which is invoked for each element in array to generate the value to be averaged. The iteratee is invoked with one argument: (value).
' @since 0.0.21
' @category Math
' @param {Array} array - The array to iterate over
' @param {Function} iteratee - The iteratee invoked per element
' @returns {Dynamic} Returns the mean value
function rodash_meanBy(array, iteratee = Invalid)
    if rodash_isEmpty(array) then
        return Invalid
    end if
    return rodash_divide(rodash_sumBy(array, iteratee), array.count())
end function

' Computes the minimum value of array. If array is empty or falsey, invalid is returned.
' @since 0.0.21
' @category Math
' @param {Array} array - The array to iterate over
' @returns {Dynamic} Returns the minumum value
function rodash_min(array = CreateObject("roArray", 0, true) as Object) as Dynamic
    return rodash_minBy(array)
end function

' Computes the minimum value of array. If array is empty or falsey, invalid is returned.
' @since 0.0.21
' @category Math
' @param {Array} array - The array to iterate over
' @returns {Dynamic} Returns the maximum value
function rodash_minBy(array = CreateObject("roArray", 0, true) as Object, iteratee = Invalid) as Dynamic
    if rodash_isEmpty(array) then
        return Invalid
    end if
    minValue = Invalid
    if (type(iteratee) = "<uninitialized>" OR iteratee = Invalid) then
        minValue = rodash_internal_getConstants().max_int
        for each value in array
            if (value < minValue) then
                minValue = value
            end if
        end for
    else if rodash_isFunction(iteratee) AND (type(array[0]) = "roAssociativeArray") then
        minValue = array[0]
        for each value in array
            if (iteratee(value) < iteratee(minValue)) then
                minValue = value
            end if
        end for
    else if (type(iteratee) = "String" OR type(iteratee) = "roString") AND (type(array[0]) = "roAssociativeArray") then
        minValue = array[0]
        for each value in array
            if (value[iteratee] < minValue[iteratee]) then
                minValue = value
            end if
        end for
    end if
    return minValue
end function

' Multiplies two numbers.
' @since 0.0.21
' @category Math
' @param {Dynamic} multiplier - The first number in a multiplication.
' @param {Dynamic} multiplicand - The second number in a multiplication.
' @returns {Dynamic} - Returns the product of the two numbers.
function rodash_multiply(multiplier as dynamic, multiplicand as dynamic) as dynamic
    if (NOT (type(multiplier) = "Integer" OR type(multiplier) = "roInt" OR type(multiplier) = "roInteger" OR type(multiplier) = "LongInteger" OR type(multiplier) = "Float" OR type(multiplier) = "roFloat" OR type(multiplier) = "Double" OR type(multiplier) = "roDouble" OR type(multiplier) = "roIntrinsicDouble")) OR (NOT (type(multiplicand) = "Integer" OR type(multiplicand) = "roInt" OR type(multiplicand) = "roInteger" OR type(multiplicand) = "LongInteger" OR type(multiplicand) = "Float" OR type(multiplicand) = "roFloat" OR type(multiplicand) = "Double" OR type(multiplicand) = "roDouble" OR type(multiplicand) = "roIntrinsicDouble"))
        return 0
    end if
    return multiplier * multiplicand
end function

' Gets the number of milliseconds that have elapsed since the Unix epoch (1 January 1970 00:00:00 UTC).
' @since 0.0.21
' @category Date
' @returns {Object} The number of milliseconds that have elapsed since the Unix epoch.
function rodash_now() as Object
    dateObj = rodash_internal_getDateObject()
    return {
        "utc": dateObj.utc.asSeconds() + dateObj.utc.getMilliseconds()
        "local": dateObj.utc.asSeconds() + dateObj.utc.getMilliseconds()
    }
end function

' The opposite of rodash.pick; this method creates an object composed of the own and inherited enumerable property paths of object that are not omitted.
' @since 0.0.23
' @category Object
' @param {Object} object - The source object.
' @param {Array} paths - The property paths to omit.
' @returns {Dynamic} - Returns the new object.
function rodash_omit(object as Object, paths = CreateObject("roArray", 0, true) as Object) as Dynamic
    result = CreateObject("roAssociativeArray")
    for each key in object.keys()
        if rodash_indexOf(paths, key) = -1 then
            result[key] = object[key]
        end if
    end for
    return result
end function

' This method is like `sortBy` except that it allows specifying the sort
' orders of the iteratees to sort by. If `orders` is unspecified, all values
' are sorted in ascending order. Otherwise, specify an order of "desc" for
' descending or "asc" for ascending sort order of corresponding values.
' You may also specify a compare function for an order.
' @since 0.0.21
' @category Array
' @param {Dynamic} collection - The collection to shuffle
' @param {Dynamic} [iteratee] - The iteratees to sort by
' @param {Dynamic} [orders] - The sort orders of `iteratees`.
' @returns {Array} Returns the new ordered array
function rodash_orderBy(collection, iteratees, orders) as Object
    if (type(collection) = "<uninitialized>" OR collection = Invalid) OR NOT (type(collection) = "roArray") then
        return []
    end if
    if NOT (type(iteratees) = "roArray") then
        iteratees = bslib_ternary(iteratees = Invalid, [], [
            iteratees
        ])
    end if
    if NOT (type(orders) = "roArray") then
        orders = bslib_ternary(orders = Invalid, [], [
            orders
        ])
    end if
    returnCollection = rodash_clone(collection)
    n = returnCollection.Count()
    for i = 0 to n - 2
        for j = 0 to n - i - 2
            if rodash_internal_orderByCompare(returnCollection[j], returnCollection[j + 1], iteratees, orders)
                ' Swap returnCollection[j] and returnCollection[j + 1]
                temp = returnCollection[j]
                returnCollection[j] = returnCollection[j + 1]
                returnCollection[j + 1] = temp
            end if
        end for
    end for
    return returnCollection
end function

' Add padding to the supplied value after converting to a string. For example "1" to "01".
' @since 0.0.22
' @category String
' @param {String} value The value to add padding to.
' @param {Integer} padLength The minimum output string length.
' @param {String} paddingCharacter The string to use as padding.
' @returns {String} Resulting padded string.
function rodash_padString(value as Dynamic, padLength = 2 as Integer, paddingCharacter = "0" as Dynamic) as String
    value = rodash_toString(value)
    while value.len() < padLength
        value = paddingCharacter + value
    end while
    return value
end function


' Alias to `rodsah.padString`
' @since 0.0.21
' @category String
function rodash_paddString(value as Dynamic, padLength = 2 as Integer, paddingCharacter = "0" as Dynamic) as String
    return rodash_padString(value, padLength, paddingCharacter)
end function

' Creates an object composed of the picked object properties.
' @since 0.0.23
' @category Object
' @param {Object} object - The object to pick from.
' @param {Array} paths - The property paths to pick.
' @returns {Dynamic} - Returns the picked value.
function rodash_pick(object as Object, paths = CreateObject("roArray", 0, true) as Object) as Dynamic
    picked = CreateObject("roAssociativeArray")
    object = rodash_clone(object)
    for each key in paths
        if object.doesExist(key) then
            picked[key] = object[key]
        end if
    end for
    return picked
end function

' Generates a random number between the lower and upper bounds.
' @since 0.0.21
' @category Number
function rodash_random(lower = 0 as dynamic, upper = 1 as dynamic, floating = false as boolean) as dynamic
    if floating then
        return lower + rnd(0) * (upper - lower)
    end if
    return lower + int(rnd(0) * (upper - lower + 1))
end function

' Reduces collection to a value which is the accumulated result of running each element in collection thru iteratee, where each successive invocation is supplied the return value of the previous. If accumulator is not given, the first element of collection is used as the initial value. The iteratee is invoked with four arguments:(accumulator, value, index|key, collection).
' @since 0.0.21
' @category Collection
' @param {Dynamic} collection - The collection to iterate over
' @param {Dynamic} iteratee - The function invoked per iteration
' @param {Integer} accumulator - The initial value
' @returns {Array} Returns the accumulated value
function rodash_reduce(collection = Invalid as Dynamic, iteratee = Invalid as Dynamic, accumulator = Invalid as Dynamic)
    result = accumulator
    if (type(iteratee) = "<uninitialized>" OR iteratee = Invalid) then
        return collection
    else if rodash_isFunction(iteratee) then
        if (type(collection) = "roArray") then
            for each item in collection
                result = iteratee(result, item)
            end for
        else if (type(collection) = "roAssociativeArray") then
            for each key in collection.keys()
                item = collection[key]
                result = iteratee(result, item, key)
            end for
        end if
    end if
    return result
end function

' Computes number rounded up to precision.
' @since 0.0.21
' @category Math
' @param {Float} num - The number to round.
' @param {Dynamic} precision - The precision to round to.
' @returns {Dynamic} - Returns the rounded number.
function rodash_round(num as Float, precision = 0 as Integer) as Float
    if num >= 0 then
        return rodash_floor(num + 0.5 * 10 ^ (-precision), precision)
    else
        return rodash_ceil(num - 0.5 * 10 ^ (-precision), precision)
    end if
end function

' Gets a random element from collection.
' @since 0.0.23
' @category Collection
' @param {Dynamic} collection - The collection to sample
' @returns {Dynamic} - Returns the random element
function rodash_sample(collection = invalid as dynamic)
    if not (type(collection) = "roArray") then
        return invalid
    end if
    return collection[rodash_random(0, collection.count() - 1)]
end function

' Gets n random elements at unique keys from collection up to the size of collection.
' @since 0.0.23
' @category Collection
' @param {Dynamic} collection - The collection to sample
' @param {Integer} n - The number of elements to sample
' @returns {Dynamic} - Returns the random elements.
function rodash_sampleSize(collection as Object, n as Integer) as Object
    result = CreateObject("roArray", 0, true)
    if (type(collection) = "roArray" AND NOT collection.isEmpty()) then
        ' Create a copy of the original array to avoid modifying it
        copyCollection = rodash_clone(collection)
        count = copyCollection.count()
        ' Limit n to the collection size
        if n > count then
            n = count
        end if
        ' Perform Fisher-Yates shuffle for the first n elements
        for i = 0 to n - 1
            ' Generate random index between i and count - 1
            j = rodash_random(i, count - 1)
            ' Swap the current element with the element at index j
            temp = copyCollection[i]
            copyCollection[i] = copyCollection[j]
            copyCollection[j] = temp
            ' Add the swapped element to the result
            result.push(copyCollection[i])
        end for
    end if
    return result
end function

' Used to set a nested String value in the supplied object
' @since 0.0.21
' @category Object
' @param {Object} aa - Object to drill down into.
' @param {String} keyPath - A dot notation based string to the expected value.
' @param {Dynamic} value - The value to be set.
' @returns {Boolean} True if set successfully.
function rodash_set(aa as Object, keyPath as String, value as Dynamic) as Boolean
    if NOT (type(aa) = "roAssociativeArray") then
        return false
    end if
    level = aa
    keys = rodash_internal_sanitizeKeyPath(keyPath).tokenize(".")
    while keys.count() > 1
        key = keys.shift()
        if NOT (type(level[key]) = "roAssociativeArray") then
            level[key] = CreateObject("roAssociativeArray")
        end if
        level = level[key]
    end while
    finalKey = keys.shift()
    level[finalKey] = value
    return true
end function

' Creates an array of shuffled values, using a version of the Fisher-Yates shuffle.
' @since 0.0.21
' @category Collection
' @param {Dynamic} collection - The collection to shuffle
' @returns {Array} Returns the new shuffled array
function rodash_shuffle(collection = CreateObject("roArray", 0, true) as Object)
    return rodash_sampleSize(collection, collection.count())
end function

' Gets the size of collection by returning its length for array-like values or the number of own enumerable string keyed properties for objects.
' @since 0.0.21
' @category Collection
' @param {Dynamic} collection - The collection to inspect
' @returns {Integer} Returns the collection size.
function rodash_size(collection = Invalid as Dynamic)
    if (type(collection) = "<uninitialized>" OR collection = Invalid) OR (NOT (type(collection) = "roArray") AND NOT (type(collection) = "roAssociativeArray") AND NOT (type(collection) = "String" OR type(collection) = "roString")) then
        return []
    end if
    if (type(collection) = "roAssociativeArray") then
        collection = rodash_toArray(collection)
    else if (type(collection) = "String" OR type(collection) = "roString") then
        return collection.len()
    end if
    return collection.count()
end function

' Creates a slice of array from start up to, but not including, end.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to slice
' @param {Integer} startPos - The start position
' @param {Integer} endPos - The end position
' @returns {Dynamic} Returns the slice of array
function rodash_slice(array = CreateObject("roArray", 0, true) as Object, startPos = 0, endPos = Invalid)
    if NOT (type(array) = "roArray") then
        return Invalid
    end if
    if (type(endPos) <> "<uninitialized>" AND endPos <> Invalid) then
        endPos = endPos - 1
    end if
    array = rodash_clone(array)
    arraySize = array.count()
    lastIndex = arraySize - 1
    slicedArray = CreateObject("roArray", 0, true)
    if startPos < 0 then
        startPos = arraySize + startPos
    end if
    if endPos = Invalid then
        endPos = lastIndex
    end if
    if endPos < 0 then
        endPos = arraySize + endPos
    end if
    if endPos >= arraySize then
        endPos = lastIndex
    end if
    if startPos >= arraySize OR startPos > endPos then
        return slicedArray
    end if
    for i = startPos to endPos
        slicedArray.push(array[i])
    end for
    return slicedArray
end function

' Creates an array of elements, sorted in ascending order by the results of running each element in a collection thru each iteratee. This method performs a stable sort, that is, it preserves the original sort order of equal elements. The iteratees are invoked with one argument: (value).
' @since 0.0.21
' @category Collection
' @param {Dynamic} collection - The collection to sort
' @param {Dynamic} iteratee - The iteratees to sort by
' @returns {Array} Returns the new sorted array
function rodash_sortBy(collection = Invalid as Dynamic, iteratee = Invalid as Dynamic)
    if (type(collection) = "<uninitialized>" OR collection = Invalid) OR NOT (type(collection) = "roArray") then
        return collection
    end if
    returnCollection = rodash_clone(collection)
    if (type(iteratee) = "roArray") then
        for each iteration in iteratee
            if (type(iteration) = "String" OR type(iteration) = "roString") then
                returnCollection.sortBy(iteration)
            end if
        end for
    else if rodash_isFunction(iteratee) then
        key = ""
        for each aa in collection
            for each key in aa.keys()
                if rodash_isEqual(aa[key], iteratee(aa)) then
                    exit for
                end if
            end for
            if NOT key = "" then
                exit for
            end if
        end for
        if NOT key = "" then
            returnCollection.sortBy(key)
        end if
    end if
    return returnCollection
end function

' Uses a binary search to determine the lowest index at which value should be inserted into array in order to maintain its sort order.
' @since 0.0.21
' @category Array
' @param {Array} array - The sorted array to inspect
' @returns {Object} Returns the index at which value should be inserted into array
function rodash_sortedIndex(array = CreateObject("roArray", 0, true) as Object, value = 0 as Integer)
    for i = 0 to array.count() - 1
        item = array[i]
        nextItem = array[i + 1]
        if (type(nextItem) <> "<uninitialized>" AND nextItem <> Invalid) then
            if (item >= value AND value <= nextItem) then
                return i
            end if
        end if
    end for
    return i
end function

' Computes the square of the value.
' @since 0.0.30
' @category Math
' @param {Integer} value - The value to multiple by itself
' @returns {Integer} Returns the square of the value
function rodash_square(value as Integer) as Dynamic
    if NOT (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble") then
        return Invalid
    end if
    return value * value
end function

' Check for the existence of a given sub string
' @since 0.0.21
' @category String
' @param {String} value The string to search
' @param {String} subString The sub string to search for
' @returns {Boolean} Results of the search
function rodash_stringIncludes(value as String, subString as String) as Boolean
    return value.Instr(subString) > -1
end function

' Finds the sub string index position
' @since 0.0.21
' @category String
' @param {String} value The string to search
' @param {String} subString The sub string to search for
' @returns {Integer} Results of the search
function rodash_stringIndexOf(value as String, subString as String) as Integer
    return value.Instr(subString)
end function

' Subtract two numbers.
' @since 0.0.21
' @category Math
' @param {Integer} minuend - The first number in a subtraction
' @param {Integer} subtrahend - The second number in a subtraction
' @returns {Integer} Returns the difference.
function rodash_subtract(minuend as Dynamic, subtrahend as Dynamic) as Dynamic
    if (NOT (type(minuend) = "Integer" OR type(minuend) = "roInt" OR type(minuend) = "roInteger" OR type(minuend) = "LongInteger" OR type(minuend) = "Float" OR type(minuend) = "roFloat" OR type(minuend) = "Double" OR type(minuend) = "roDouble" OR type(minuend) = "roIntrinsicDouble")) OR (NOT (type(subtrahend) = "Integer" OR type(subtrahend) = "roInt" OR type(subtrahend) = "roInteger" OR type(subtrahend) = "LongInteger" OR type(subtrahend) = "Float" OR type(subtrahend) = "roFloat" OR type(subtrahend) = "Double" OR type(subtrahend) = "roDouble" OR type(subtrahend) = "roIntrinsicDouble"))
        return 0
    end if
    return minuend - subtrahend
end function

' Computes the sum of the values in an array.
' @since 0.0.21
' @category Math
' @param {Array} array - The array to sum
' @returns {Integer} Returns the sum of the values in the array
function rodash_sum(array as Object)
    if NOT (type(array) = "roArray") then
        return 0
    end if
    sumValue = 0
    for each item in array
        sumValue += item
    end for
    return sumValue
end function

' This method is like `sum` except that it accepts `iteratee` which is invoked for each element in array to generate the value to be summed.
' The iteratee is invoked with one argument: (value).
' @since 0.0.21
' @category Math
' @param {Array} array - The array to iterate over
' @param {Function} iteratee - The iteratee invoked per element
' @returns {Integer} Returns the sum
function rodash_sumBy(array = CreateObject("roArray", 0, true) as Object, iteratee = Invalid) as Dynamic
    if rodash_isEmpty(array) then
        return Invalid
    end if
    sumValue = Invalid
    if (type(iteratee) = "<uninitialized>" OR iteratee = Invalid) then
        sumValue = 0
        for each value in array
            sumValue += value
        end for
    else if rodash_isFunction(iteratee) AND (type(array[0]) = "roAssociativeArray") then
        sumValue = 0
        for each value in array
            sumValue += iteratee(value)
        end for
    else if (type(iteratee) = "String" OR type(iteratee) = "roString") AND (type(array[0]) = "roAssociativeArray") then
        sumValue = 0
        for each value in array
            sumValue += value[iteratee]
        end for
    end if
    return sumValue
end function

' Creates a slice of array with n elements taken from the beginning
' @since 0.0.21
' @category Array
' @param {Array} array - The sorted array to query
' @param {Integer} n - The number of elements to take
' @returns {Object} Returns the slice of array
function rodash_take(array = CreateObject("roArray", 0, true) as Object, n = Invalid as Dynamic) as Object
    if (type(n) = "<uninitialized>" OR n = Invalid) then
        n = 1
    end if
    if NOT (type(array) = "roArray" AND NOT array.isEmpty()) OR n = 0 then
        return CreateObject("roArray", 0, true)
    end if
    return rodash_slice(array, 0, n)
end function

' Creates a slice of array with n elements taken from the end
' @since 0.0.21
' @category Array
' @param {Array} array - The sorted array to query
' @param {Integer} n - The number of elements to take
' @returns {Object} Returns the slice of array
function rodash_takeRight(array = CreateObject("roArray", 0, true) as Object, n = Invalid as Dynamic) as Object
    if (type(n) = "<uninitialized>" OR n = Invalid) then
        n = 1
    end if
    if NOT (type(array) = "roArray" AND NOT array.isEmpty()) OR n = 0 then
        return CreateObject("roArray", 0, true)
    end if
    length = array.count()
    startPos = length - n
    if startPos < 0 then
        startPos = 0
    end if
    return rodash_slice(array, startPos, length)
end function

' Invokes the iteratee n times, returning an array of the results of each invocation. The iteratee is invoked with one argument; (index).
' @since 0.0.24
' @category Utils
' @param {Integer} n - The number of times to invoke iteratee.
' @param {Function} iteratee - The function invoked per iteration.
' @returns {Array} Returns the array of results.
' @example
' rodash.times(3, rodash.toString) ' => ["0", "1", "2"]
' rodash.times(4, rodash.isNumber) ' => [true, true, true, true]
' rodash.times(4, rodash.isString) ' => [false, false, false, false]
function rodash_times(n = 0 as Integer, iteratee = Invalid as Dynamic) as Object
    returnArray = CreateObject("roArray", 0, true)
    if NOT (type(n) = "Integer" OR type(n) = "roInt" OR type(n) = "roInteger" OR type(n) = "LongInteger") then
        return returnArray
    end if
    for i = 0 to n - 1
        returnArray.push(iteratee(i))
    end for
    return returnArray
end function

' Attempts to convert the supplied value to a array.
' @since 0.0.21
' @category Lang
' @todo Add more support for other types.
' @param {Dynamic} value The value to convert.
' @returns {Object} Results of the conversion.
function rodash_toArray(input as Dynamic) as Object
    arr = CreateObject("roArray", 0, true)
    inputType = type(input)
    if (inputType = "roAssociativeArray") then
        ' Get values from associative array
        for each key in input.keys()
            arr.push(input[key])
        end for
    else if (inputType = "String" OR inputType = "roString") then
        arr = input.split("")
    else
        ' For anything else (numbers, invalid), return an empty array
        arr = CreateObject("roArray", 0, true)
    end if
    return arr
end function

' Converts a date object to an ISO string
' @since 0.0.21
' @category Date
' @returns {String} Returns the date object as an ISO string
function rodash_toISOString(dateObj = Invalid as Dynamic) as String
    if ((type(dateObj) = "roDateTime")) then
        return ""
    end if
    return dateObj.toISOString()
end function

' Attempts to convert the supplied value into a valid number
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The variable to be converted
' @returns {Dynamic} Results of the conversion
' @example
' rodash.toNumber("1") // => 1
' rodash.toNumber("1.0") // => 1.0
' rodash.toNumber(1) // => 1
' rodash.toNumber(1.0#) // => 1.0
' rodash.toNumber(true) // => 1
' rodash.toNumber(false) // => 0
function rodash_toNumber(value as Dynamic) as Dynamic
    if (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble") then
        return value
    else if (type(value) = "Boolean" OR type(value) = "roBoolean") then
        if value then
            return 1
        end if
        return 0
    end if
    if (type(value) = "String" OR type(value) = "roString") then
        ' TODO: Temporary fix until we figure a better way to avoid val converting 8037667 to 8.03767e+06
        if (value.Instr(".") > -1) then
            return val(value)
        else
            return val(value, 10)
        end if
    end if
    return 0
end function

' Creates an array of own enumerable string keyed-value pairs for object which can be consumed by rodash.fromPairs. If object is a map or set, its entries are returned.
' @since 0.0.24
' @category Array
' @param {Object} obj - The object to query.
' @returns {Array} Returns the key-value pairs.
' @example
' rodash.toPairs({ 'a': 1, 'b': 2 }) // => [['a', 1], ['b', 2]]
' rodash.toPairs({ 'a': 1, 'b': 2, 'c': 3 }) // => [['a', 1], ['b', 2], ['c', 3]]
function rodash_toPairs(obj = CreateObject("roAssociativeArray") as Object) as Object
    returnArray = CreateObject("roArray", 0, true)
    if NOT (type(obj) = "roAssociativeArray") then
        return returnArray
    end if
    for each key in obj.keys()
        returnArray.push([
            key
            obj[key]
        ])
    end for
    return returnArray
end function

' Attempts to convert the supplied value to a string.
' @since 0.0.21
' @category Lang
' @param {Dynamic} value The value to convert.
' @returns {String} Results of the conversion.
' @example
' rodash.toString(1) // => "1"
' rodash.toString(1.0#) // => "1.0"
' rodash.toString(true) // => "true"
' rodash.toString(false) // => "false"
function rodash_toString(value as Dynamic) as String
    if (type(value) = "String" OR type(value) = "roString") then
        return value
    end if
    if (type(value) = "Integer" OR type(value) = "roInt" OR type(value) = "roInteger" OR type(value) = "LongInteger" OR type(value) = "Float" OR type(value) = "roFloat" OR type(value) = "Double" OR type(value) = "roDouble" OR type(value) = "roIntrinsicDouble") then
        return (value.toStr())
    end if
    if rodash_isNode(value) then
        return rodash_internal_nodeToString(value)
    end if
    if (type(value) = "Boolean" OR type(value) = "roBoolean") then
        return rodash_internal_booleanToString(value)
    end if
    if (type(value) = "roAssociativeArray") then
        return rodash_internal_aaToString(value)
    end if
    if (type(value) = "roArray") then
        return rodash_internal_arrayToString(value)
    end if
    return ""
end function

' Creates an array of unique values, in order, from all given arrays using SameValueZero for equality comparisons.
' @since 0.0.21
' @category Array
' @param {Array} arrays - The arrays to inspect
' @returns {Object} Returns the new array of combined values
' @example
' rodash.union([[2], [1, 2]]) // => [2, 1]
' rodash.union([[2], [1, 2], [2, 3]]) // => [2, 1, 3]
function rodash_union(arrays = CreateObject("roArray", 0, true) as Object) as Object
    return rodash_uniq(rodash_flattenDeep(arrays))
end function

' Creates a duplicate-free version of an array, using SameValueZero for equality comparisons, in which only the first occurrence of each element is kept. The order of result values is determined by the order they occur in the array.
' @since 0.0.21
' @category Array
' @param {Array} array - The array to inspect
' @returns {Object} Returns the new duplicate free array
function rodash_uniq(array = CreateObject("roArray", 0, true) as Object) as Object
    returnArray = CreateObject("roArray", 0, true)
    table = CreateObject("roAssociativeArray")
    for each item in array
        key = item.toStr()
        if NOT table.doesExist(key)
            returnArray.push(item)
            table[key] = true
        end if
    end for
    return returnArray
end function

' Creates a duplicate-free version of an array, in which only the first occurrence of each element is kept. The order of result values is determined by the order they occur in the array.
' By default, when comparing arrays and associative arrays the function will compare the values on the elements. If the strict parameter is set to true, the function will compare the references of the AA and Array elements.
' @since 0.0.29
' @category Array
' @param {Array[]} array - The arrays to inspect
' @param {Boolean} strict - If true, the function will compare the references of the AA and Array elements
' @returns {Array} Returns the new array of filtered values.
' @example
' rodash.xor([[2, 1], [2, 3]]) // => [1, 3]
' rodash.xor([[2, 1], [2, 3], [2, 3]]) // => [1]
function rodash_xor(arrays as Object, strict = false as Object) as Object
    ' Create an array to store the result of the XOR operation (elements with count 1)
    resultArray = []
    removeArray = []
    for each array in arrays
        for each item in array
            ' If the item is not in the result array, add it
            if rodash_findIndex(resultArray, item, 0, strict) = -1
                resultArray.push(item)
            else
                ' If the item is already in the result array, remove it
                removeArray.push(item)
            end if
        end for
    end for
    print "resultArray: "; resultArray
    print "removeArray: "; removeArray
    while removeArray.count() > 0
        ' Remove the first occurrence of the item in removeArray from resultArray
        resultArray.delete(rodash_findIndex(resultArray, removeArray[0]))
        ' Remove the first item from removeArray
        removeArray.delete(0)
    end while
    return resultArray
end function

' Creates an array of grouped elements, the first of which contains the first elements of the given arrays, the second of which contains the second elements of the given arrays, and so on.
' @since 0.0.21
' @category Array
' @param {Array} arrays - The property identifiers
' @returns {Object} Returns the new array of grouped elements
function rodash_zip(arrays = CreateObject("roArray", 0, true) as Object) as Object
    returnArray = CreateObject("roArray", 0, true)
    for i = 0 to arrays.count() - 1
        array = arrays[i]
        for ii = 0 to array.count() - 1
            if (type(returnArray[ii]) = "<uninitialized>" OR returnArray[ii] = Invalid) then
                returnArray[ii] = CreateObject("roArray", 0, true)
            end if
            returnArray[ii].push(array[ii])
        end for
    end for
    return returnArray
end function

' This method is like rodash.fromPairs except that it accepts two arrays, one of property identifiers and one of corresponding values.
' @since 0.0.21
' @category Array
' @param {Array} array - The property identifiers
' @param {Array} values - The property values
' @returns {Object} Returns the new object
function rodash_zipObject(props = CreateObject("roArray", 0, true) as Object, values = CreateObject("roArray", 0, true) as Object) as Object
    returnObject = CreateObject("roAssociativeArray")
    for i = 0 to props.count() - 1
        returnObject[props[i]] = values[i]
    end for
    return returnObject
end function

' This method is like rodash.zipObject except that it supports property paths.
' @ignore
' @category Array
' @param {Array} array - The property identifiers
' @param {Array} values - The property values
' @returns {Object} Returns the new object
function rodash_zipObjectDeep(props = CreateObject("roArray", 0, true) as Object, values = CreateObject("roArray", 0, true) as Object) as Object
    ' COME BACK
end function