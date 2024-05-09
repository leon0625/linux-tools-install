#!/usr/bin/env python3

# 把系统配置同步到github,或者从github同步到本地

import subprocess,os,re

# 文件映射规则
files = [
    (
        '~/.zshrc', # 本地
        'config/.zshrc'    # github
    ), 
    (
        '~/.oh-my-zsh/themes/leon.zsh-theme',
        'config/ohmyzsh/leon.zsh-theme'
    )
]

def sync_to_github():
    print('同步到github...')
    for local, github in files:
        local = re.sub('^~', os.getenv('HOME'), local)
        print(f'{local} ===> {github}')
        subprocess.run(['cp', '-rf', local, github]) 

def sync_to_local():
    print('从github同步到本地...')
    for local, github in files:
        local = re.sub('^~', os.getenv('HOME'), local)
        print(f'{github} ===> {local}')
        subprocess.run(['cp', '-rf', github, local])


prompt='''请选择同步方向：
1 - 从本地同步到github
2 - 从github同步到本地
'''
sync_type = input(prompt)
if sync_type == '1':
    sync_to_github()
elif sync_type == '2':
    sync_to_local()
else:
    print('输入有误')