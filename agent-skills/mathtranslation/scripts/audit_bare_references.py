"""Inventory possible unlinked references; never rewrite from regex alone."""
from pathlib import Path
import argparse, json, re

def group_end(text, start):
    depth = 0
    for i in range(start, len(text)):
        if text[i] in '{}':
            n = 0; j = i - 1
            while j >= 0 and text[j] == '\\': n += 1; j -= 1
            if n % 2: continue
            depth += 1 if text[i] == '{' else -1
            if depth == 0: return i + 1
    raise ValueError('Unbalanced argument at ' + str(start))

def mask_tex(text):
    # Keep offsets/newlines. Math is deliberately retained: references occur in math.
    chars = list(text)
    def hide(a, b):
        for i in range(a, b):
            if chars[i] not in '\r\n': chars[i] = ' '
    for m in re.finditer(r'%[^\r\n]*', text):
        n = 0; j = m.start()-1
        while j >= 0 and text[j] == '\\': n += 1; j -= 1
        if n % 2 == 0: hide(*m.span())
    for m in re.finditer(r'\\begin\{(verbatim\*?|lstlisting|minted)\}.*?\\end\{\1\}', text, re.S): hide(*m.span())
    # Mask existing links and metadata/citation arguments, not footnote/erratum prose.
    cmd = re.compile(r'\\(?:[A-Za-z]*cite[A-Za-z]*\*?|label|tag\*?|(?:eq|page|auto|name|[A-Za-z]*cref|thm|prop|lem|cor|def|rem|ex|prob)?ref\*?|hyperref|hyperlink|href|hypertarget|index|include|input)(?![A-Za-z])')
    for m in cmd.finditer(text):
        if chars[m.start()] == ' ': continue
        p = m.end(); name = m.group()[1:].rstrip('*')
        while p < len(text) and text[p].isspace(): p += 1
        while p < len(text) and text[p] == '[':
            close = text.find(']', p)
            if close < 0: break
            p = close + 1
            while p < len(text) and text[p].isspace(): p += 1
        count = 2 if name in {'hyperlink','href','hypertarget'} else 1
        for _ in range(count):
            if p < len(text) and text[p] == '{':
                p = group_end(text, p)
                while p < len(text) and text[p].isspace(): p += 1
        hide(m.start(), p)
    return ''.join(chars)

PATTERNS = {
    'parenthesized': r'[（(]\s*(?:[IVX]+[,，.\s]*)?(?:\d+(?:\.\d+)*[a-z]?(?:\([a-z]\))?)(?:\s*[,，、;；–—-]\s*\d+(?:\.\d+)*[a-z]?)*\s*[)）]',
    'decimal': r'(?<![\w.])\d+\.\d+(?:\.\d+)*[a-z]?(?![\w.])',
    'section': r'(?:\\S(?![A-Za-z])|§)\s*~?\s*(?:[IVX]+[.,，\s]*)?\d+(?:\.\d+)*',
    'named': r'(?:定理|命题|引理|推论|定义|习题|问题|例|注记|公式|方程|见|参见|参看|第)\s*~?\s*(?:[IVX]+[.,，\s]*)?\d+(?:\.\d+)*',
    'chapter': r'第\s*(?:[IVX]+|\d+|[一二三四五六七八九十]+)\s*章',
    'page': r'(?:第\s*\d+\s*页|\bp(?:age)?\.\s*~?\s*\d+)',
    'chinese_section': r'第\s*(?:\d+|[一二三四五六七八九十]+)\s*节',
    'roman': r'(?<![A-Za-z])(?:VIII|VII|VI|IV|III|II|IX|V|I)[,，.]\s*(?:\\S\s*)?\d+(?:\.\d+)*',
}

def scan(path):
    raw = path.read_bytes().decode('utf-8-sig'); masked = mask_tex(raw)
    hits = {}
    for kind, pattern in PATTERNS.items():
        for m in re.finditer(pattern, masked):
            key = m.span()
            hits.setdefault(key, []).append(kind)
    result = []
    for (a,b), kinds in sorted(hits.items()):
        result.append({'file':str(path), 'line':raw.count('\n',0,a)+1, 'start':a, 'end':b,
                       'text':raw[a:b], 'kinds':kinds,
                       'context':raw[max(0,a-65):min(len(raw),b+85)].replace('\r','').replace('\n',' ')})
    return result

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('files', nargs='+', type=Path, help='Actual compiled TeX files, including front/back matter')
    ap.add_argument('--output', required=True, type=Path)
    args=ap.parse_args(); rows=[r for p in args.files for r in scan(p)]
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8')
    print(f'{len(rows)} candidates; classification required: {args.output}')

if __name__=='__main__': main()
