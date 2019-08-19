Variable = require './variable'

module.exports =
class Parser
    varRegexArray: /(public|private|protected)\s*(static)?\s*(final)?\s*(volatile|transient)?\s*((?!.*class)[a-zA-Z0-9_$]+)(\<.*?\>)?\s*([a-zA-Z0-9_$,\s]+)(?!.*\((.*)\) {)/g
    varRegex: /(public|private|protected)\s*(static)?\s*(final)?\s*(volatile|transient)?\s*((?!.*class)[a-zA-Z0-9_$]+)(\<.*?\>)?\s*([a-zA-Z0-9_$,\s]+)(?!.*\((.*)\) {)/
    classNameRegex: /(?:class)\s+([a-zA-Z0-9_$]+)/
    variableNameRegex: /([a-zA-Z0-9_$]+)/g
    typeParameterRegex: /^\<.*\>$/
    classRegex: /class/
    finalRegex: /^final$/
    staticRegex: /^static$/
    content: ''

    setContent: (@content) ->

    getContent: ->
        return @content

    getVars: ->
        # Find lines with variables
        varLines = @content.match(@varRegexArray)

        # Check if any were found
        if ! varLines
            alert ('No variables were found.')
            return {}

        variables = []
        for line in varLines
            group = @varRegex.exec(line)
            if group != null
                isStatic = false
                isFinal = false
                type = group[5]

                # Check if static
                if group[2] != null && @staticRegex.test(group[2])
                    isStatic = true

                # Check if final
                if group[3] != null && @finalRegex.test(group[3])
                    isFinal = true

                # Check if we need to append a generic to the type (ie. List<T> or Map<T, T>)
                if group[6] != null && @typeParameterRegex.test(group[6])
                    type = type + group[6]

                # Check variable name, allows us to detect multiple variables on one line
                if group[7] != null && @variableNameRegex.test(group[7])
                    varNames = group[7].match(@variableNameRegex)
                    for varName in varNames
                        # Create variable and store it
                        variable = new Variable(varName, type, isStatic, isFinal)
                        variables.push (variable)

        return variables

    getClassName: ->
        # Find class name and return it
        match = @content.match(@classNameRegex)
        return match[1]
