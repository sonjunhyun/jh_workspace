import re
import numpy as np
import pandas as pd

def preprocessing(df):
    # 5대 리그 사이에서 이적이 발생할 경우, 중복 발생하므로 Transfer Id와 Name 기준으로 중복 제거 후 reindexing
    df.drop_duplicates(['Transfer Id'], inplace=True)
    df.drop_duplicates(['Name'], inplace=True)
    df.reset_index(inplace=True, drop=True)

    # Player Id, Age, Transfer Id 컬럼 정수형으로 변환
    df = df.astype({'Player Id': 'int', 'Age': 'int', 'Transfer Id': 'int'})

    # 날짜 형식 변환 및 날짜 순으로 정렬
    df['Transfer Date'] = pd.to_datetime(df['Transfer Date'])
    df.sort_values(by='Transfer Date', ascending=False, inplace=True)

    # 시장 가치 데이터 변환
    df['Market Value'] = df['Market Value'].apply(lambda x: re.search('[0-9\.]{1,}[mk]', x).group())
    df['Market Value'] = df['Market Value'].apply(lambda x: int(float(str(x)[:-1])*10e6) if str(x)[-1] == 'm' else int(float(str(x)[:-1])*10e3))

    # 임대/이적 구분
    df['Transfer Type'] = df['Fee'].apply(lambda x: 'loan' if re.search('[lL]oan.+', x) else 'unknown' if x == 'unknown' else 'transfer')

    # 비용 데이터 변환
    df['Fee'] = df['Fee'].apply(lambda x: re.search('[0-9\.]{1,}[mk]', x).group() if re.search('[0-9\.]{1,}[mk]', x) else np.NaN if x == 'unknown' else 0)
    df['Fee'] = df['Fee'].apply(lambda x: int(float(str(x)[:-1])*10e6) if str(x)[-1] == 'm' else int(float(str(x)[:-1])*10e3) if str(x)[-1] == 'k'else x)

    # Market Value, Fee column명 변경
    df.rename(columns={'Market Value': 'Market Value (€)', 'Fee': 'Fee (€)'}, inplace=True)
    
    return df