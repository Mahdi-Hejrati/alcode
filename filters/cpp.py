
def cap(str):
    return str.capitalize()

def type(str):
    mappings = {
        'Int8': 'int',
        'Int16': 'int',
        'Int32': 'int',
        'Int64': 'int',
        'Real32': 'double',
        'Real64': 'double',
        'String': 'string',
        'Binary': 'binary',
        'bool': 'bool',
    }
    return mappings.get(str, cap(str))

def defval(str):
    mappings = {
        'Int8': '0',
        'Int16': '0',
        'Int32': '0',
        'Int64': '0',
        'Real32': '0',
        'Real64': '0',
        'string': '""',
        'Binary': 'null',
        'bool': 'false',
    }
    return mappings.get(str, 'null')

def indent(str, repl):
    return str.strip().replace("\n", "\n" + repl)