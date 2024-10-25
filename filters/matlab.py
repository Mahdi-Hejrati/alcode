
def cap(str):
    return str.capitalize()

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