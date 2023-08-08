import pandas as pd
import requests
from bs4 import BeautifulSoup

def crawler():
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
        }

    league_code = ['GB1', 'ES1', 'IT1', 'L1', 'FR1']    # PL, LaLiga, Serie A, Bundesliga, Ligue 1

    transfer_info = []      # 이적 정보 추가할 리스트 생성

    for league in league_code:
        start_page = 1      # 1 페이지부터 크롤링 시작

        while True:
            url = f'https://www.transfermarkt.com/transfers/neuestetransfers/statistik/plus/plus/1/galerie/0/wettbewerb_id/{league}/land_id//minMarktwert/500.000/maxMarktwert/500.000.000/minAbloese/0/maxAbloese/500.000.000/yt0/Show/page/{start_page}?ajax=yw1'
            response = requests.get(url, headers=headers)
            soup = BeautifulSoup(response.text, 'html.parser')

            transfer_lists = soup.select('tr.odd, tr.even')     # 이적 정보 목록
            end_page = int(soup.select('.tm-pagination__list-item > a')[-1].attrs['href'].split('/')[-1])   # league 별 이적시장 끝 페이지

            for transfer_list in transfer_lists:
                info = transfer_list.select('td')

                player_id = info[2].select_one('a').attrs['href'].split('/')[-1]
                name = info[2].text.strip()
                position = info[3].text.strip()
                age = info[4].text.strip()
                nation = info[5].img['alt']
                left = info[6].img['alt']
                joined = info[10].img['alt']
                transfer_date = info[14].text.strip()
                market_value = info[15].text.strip()
                fee = info[16].text.strip()
                transfer_id = info[16].select_one('a').attrs['href'].split('/')[-1]

                info_list = [player_id, name, position, age, nation, left, joined, transfer_date, market_value, fee, transfer_id]
                transfer_info.append(info_list)

            start_page += 1     # 다음 페이지 crawling
            if start_page > int(end_page):  # 마지막 페이지 도달 시 break
                break

    df = pd.DataFrame(transfer_info, columns=['Player Id', 'Name', 'Position', 'Age', 'Nation', 'Left', 'Joined', 'Transfer Date', 'Market Value', 'Fee', 'Transfer Id'])
    return df