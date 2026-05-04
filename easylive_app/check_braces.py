from pathlib import Path
p = Path('lib/widgets/pemilikKos/home/dashboard_widgets.dart')
text = p.read_text(encoding='utf-8')
stack = []
extra = []
for i, line in enumerate(text.splitlines(), 1):
    for c in line:
        if c == '{':
            stack.append(i)
        elif c == '}':
            if stack:
                stack.pop()
            else:
                extra.append(i)
print('lines', len(text.splitlines()))
print('extra', extra)
print('remaining', len(stack), stack[-10:])
