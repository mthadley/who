#!/usr/bin/env python3
import json
import multiprocessing
import optparse
import os
import sys

from collections import namedtuple
from operator import attrgetter
from pathlib import Path
from urllib.request import urlopen

DATA_DIR = Path("dist/data")
LEGISLATORS_DIR = DATA_DIR / "legislators"
PHOTO_DIR = DATA_DIR / "photos"

BASE_URL = "http://theunitedstates.io/"
LEGISLATORS_URL = BASE_URL + "congress-legislators/legislators-current.json"

BASE_AVATAR_URL = "http://bioguide.congress.gov/bioguide/photo"


def photo_worker(leg):
    id = leg.id
    try:
        path = (PHOTO_DIR / id).with_suffix(".jpg")
        if not path.exists():
            response = urlopen(leg.get_avatar_url())
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
    with urlopen(url) as response:
        return json.loads(response.read())


class Legislator(namedtuple('Legislator', [
    "first_name",
    "id",
    "last_name",
    "name",
    "party",
    "photo_url",
    "state"
        ])):

    def get_avatar_url(self):
        return f"{BASE_AVATAR_URL}/{self.last_name[0].upper()}/{self.id}.jpg"


class Downloader:

    def __init__(self, skip_images=False, url_base=""):
        self.legislators = None
        self.skip_images = skip_images
        self.url_base = url_base

    def add_photo_urls(self):
        if self.skip_images:
            return

        total = len(self.legislators)
        print("Fetching photos...")

        pool = multiprocessing.Pool()
        finished = set()
        for i, (id, status) in enumerate(
            pool.imap_unordered(photo_worker, self.legislators), 1
        ):
            if status:
                finished.add(id)
            sys.stdout.write(f"\r{i} of {total}")
            sys.stdout.flush()

        def update_photo(leg):
            if leg.id in finished:
                return leg._replace(
                        photo_url=f"{self.url_base}/data/photos/{leg.id}.jpg")
            return leg

        self.legislators = [update_photo(leg) for leg in self.legislators]

        downloaded_count = len([leg for leg in self.legislators
                                if leg.id in finished])
        failed_count = total - downloaded_count
        print(f"\n{downloaded_count} downloaded, {failed_count} failures")

    def create_index(self):
        print("Writing index file...")
        with (DATA_DIR / "index").with_suffix(".json").open("w") as file:
            data = [leg._asdict() for leg in self.legislators]
            json.dump(data, file)

    def create_individual(self):
        print(f"Writing {len(self.legislators)} data files...")
        for leg in self.legislators:
            filename = (LEGISLATORS_DIR / leg.id).with_suffix(".json")
            with filename.open("w") as file:
                json.dump(leg, file)

    def create_data_files(self):
        print("Fetching data...")

        self.legislators = [Legislator(
            first_name=leg["name"]["first"],
            id=leg["id"]["bioguide"],
            last_name=leg["name"]["last"],
            name=leg["name"]["official_full"],
            party=leg["terms"][-1]["party"],
            photo_url=None,
            state=leg["terms"][-1]["state"]
        ) for leg in read_json_url(LEGISLATORS_URL)]
        self.legislators.sort(key=attrgetter("last_name"))

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
    parser.add_option("-b", "--url-base", default="")
    options, args = parser.parse_args()

    downloader = Downloader(skip_images=options.skip_images,
                            url_base=options.url_base)
    downloader.run()
