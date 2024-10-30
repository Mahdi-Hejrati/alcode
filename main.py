from mako.template import Template
from mako.lookup import TemplateLookup
import shutil
import json
from pathlib import Path


class Struct:
    def __init__(self, entries):
        for k,v in entries.items():
            if isinstance(v, dict):
                entries[k] = Struct(v)
            if isinstance(v, list):
                entries[k] = [Struct(i) for i in v]
        self.__dict__.update(**entries)

class Root:
    project={}
    federates=[]
    topics=[]
    datatypes=[]
    users={}

with open('export-Machinery-2024-10-09 19_52_51.223637.json', 'r') as file:
    data = json.load(file)

root = Root()
root.project = Struct(data['project'])
root.datatypes = { i['id']: Struct(i) for i in data['datatypes'].values() }
root.federates = { i['id']: Struct(i) for i in data['federates'].values() }
root.topics    = { i['id']: Struct(i) for i in data['topics'].values() }
root.users     = data['users']

templateLookup = TemplateLookup(
    directories=['templates'],
    module_directory='./mako_modules',
    output_encoding='utf-8',
    default_filters=[]
)

dir = Path('output/' + root.project.proj_name)
if dir.exists():
    shutil.rmtree(dir)

templates = [ str(Path(*i.parts[1:])) for i in list(Path("./templates").rglob("*.[mM][aA][kK][oO]")) ]

for t in templates:
    tpl = templateLookup.get_template(t)
    render = tpl.render_unicode(root=root).split('ALMAS-FILE-SEPRATE')
    for r in render:
        info = r.split('ALMAS-FILE-INFO')
        text = info[0].strip()
        for i in range(1, len(info)):
            fn = Path(f"output/{root.project.proj_name}/" + info[i].strip())
            fn.parent.mkdir(parents=True, exist_ok=True)
            fn.write_text(text)


