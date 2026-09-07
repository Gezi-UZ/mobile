files = [
    ('lib/core/shared_widgets/quick_actions_bottom_sheet.dart', 16),
    ('lib/features/meter/presentation/pages/meter_list_page.dart', 236),
    ('lib/features/meter/presentation/widgets/meter_card.dart', 241),
    ('lib/features/meter/presentation/widgets/meter_card.dart', 251),
    ('lib/features/meter/presentation/widgets/meter_card.dart', 261),
    ('lib/features/report/presentation/widgets/transaction_list_item.dart', 38),
]

for filepath, line in files:
    with open(filepath, 'r') as f:
        content = f.readlines()
    
    idx = line - 1
    # Check current line and up to 2 lines above
    for i in range(max(0, idx - 2), idx + 1):
        if 'const ' in content[i]:
            content[i] = content[i].replace('const ', '')
            break
            
    with open(filepath, 'w') as f:
        f.writelines(content)
        print(f"Fixed {filepath}:{line}")
