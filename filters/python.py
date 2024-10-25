
def cap(str):
    return str.capitalize()

def type(str):
    mappings = {
        'int8': 'int',
        'int16': 'int',
        'int32': 'int',
        'int64': 'int',
        'real32': 'float',
        'real64': 'float',
        'string': 'str',
        'binary': 'any',
        'bool': 'bool',
    }
    return mappings.get(str.lower(), cap(str))

def defval(str):
    mappings = {
        'Int8': '0',
        'Int16': '0',
        'Int32': '0',
        'Int64': '0',
        'Real32': '0',
        'Real64': '0',
        'string': '""',
        'Binary': 'None',
        'bool': 'False',
    }
    return mappings.get(str, f'None')

def indent(str, repl):
    return str.strip().replace("\n", "\n" + repl)