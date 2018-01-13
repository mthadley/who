#!/usr/bin/env python3
import json
import multiprocessing
import optparse
import os
import sys

from urllib.request import urlopen
from pathlib import Path

DATA_DIR = Path("dist/data")
LEGISLATORS_DIR = DATA_DIR / "legislators"
PHOTO_DIR = DATA_DIR / "photos"

BASE_URL = "http://theunitedstates.io/"
LEGISLATORS_URL = BASE_URL + "congress-legislators/legislators-current.json"

BASE_AVATAR_URL = "http://bioguide.congress.gov/bioguide/photo"


def get_avatar_url(name, id):
    return f"{BASE_AVATAR_URL}/{name[0].upper()}/{id}.jpg"


def leg_id(leg):
    return leg["id"]["bioguide"]


def photo_worker(leg):
    id = leg_id(leg)
    try:
        path = (PHOTO_DIR / id).with_suffix(".jpg")
        if not path.exists():
            response = urlopen(get_avatar_url(leg["name"]["last"], id))
            with path.open("wb") as file:
                file.write(response.read())
        return id, True
    except Exception:
        return id, False


def init_dirs(dirs):
    for directory in [LEGISLATORS_DIR, PHOTO_DIR]:
        if not directory.exists():
            os.makedirs(directory)


def read_json_url(url):
    response = urlopen(url).read()
    return json.loads(response)


class Downloader:
    def __init__(self, skip_images=False):
        self.legislators = None
        self.skip_images = skip_images

    def add_photo_urls(self):
        if self.skip_images:
            return

        total = len(self.legislators)
        print("Fetching photos...")

        pool = multiprocessing.Pool()
        finished = set()
        for i, result in enumerate(
            pool.imap_unordered(photo_worker, self.legislators), 1
        ):
            id, status = result

            if status:
                finished.add(id)

            sys.stdout.write(f"\r{i} of {total}")
            sys.stdout.flush()

        downloaded_count = 0
        for leg in self.legislators:
            id = leg_id(leg)
            if id in finished:
                leg["photo_url"] = f"/data/photos/{id}.jpg"
                downloaded_count += 1
            else:
                leg["photo_url"] = None

        failed_count = len(self.legislators) - downloaded_count
        print(f"\n{downloaded_count} downloaded, {failed_count} failures")

    def create_index(self):
        print("Writing index file...")
        index = [{
            "first_name": leg["name"]["first"],
            "id": leg_id(leg),
            "last_name": leg["name"]["last"],
            "name": leg["name"]["official_full"],
            "party": leg["terms"][-1]["party"],
            "photo_url": leg.get("photo_url"),
            "state": leg["terms"][-1]["state"]
        } for leg in self.legislators]
        index.sort(key=lambda leg: leg["last_name"])
        with (DATA_DIR / "index").with_suffix(".json").open("w") as file:
            json.dump(index, file)

    def create_individual(self):
        print(f"Writing {len(self.legislators)} data files...")
        for leg in self.legislators:
            filename = (LEGISLATORS_DIR / leg_id(leg)).with_suffix(".json")
            with filename.open("w") as file:
                json.dump(leg, file)

    def create_data_files(self):
        print("Fetching data...")
        self.legislators = read_json_url(LEGISLATORS_URL)

        self.add_photo_urls()
        self.create_index()
        self.create_individual()

    def run(self):
        init_dirs([LEGISLATORS_DIR, PHOTO_DIR])
        self.create_data_files()
        print("Done!")


if __name__ == "__main__":
    parser = optparse.OptionParser()
    parser.add_option("-s", "--skip-images",
                      action="store_true", default=False)
    options, args = parser.parse_args()

    downloader = Downloader(skip_images=options.skip_images)
    downloader.run()
