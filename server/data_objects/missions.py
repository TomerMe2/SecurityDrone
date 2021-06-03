from dataclasses import dataclass
from enum import Enum, auto
from datetime import datetime

from typing import List


class MissionType(Enum):
    PATROL = auto(),
    GO_TO_WAYPOINT = auto(),
    GO_TO_HOME_WAYPOINT = auto(),
    TRACK = auto()


class StartReasonType(Enum):
    CLOCK = auto(),
    USER_REQUEST = auto(),
    FOUND_THIEF = auto()


class EndReasonType(Enum):
    ENDED_AS_EXPECTED = auto(),
    USER_REQUEST = auto(),
    FOUND_THIEF = auto()


@dataclass
class SubMission:
    mission_type: MissionType
    start_reason: StartReasonType
    end_reason: EndReasonType
    start_time: datetime
    end_time: datetime

    @staticmethod
    def from_dict(data_dct):
        if 'lat_to_go' in data_dct and 'lon_to_go' in data_dct:
            return GoToWaypointMission.from_dict(data_dct)

        return {
            SubMission(**data_dct)
        }

    def to_dict(self):
        return {
            'mission_type': self.mission_type,
            'start_reason': self.start_reason,
            'end_reason': self.end_reason,
            'start_time': self.start_time,
            'end_time': self.end_time
        }


@dataclass
class Mission:
    mission_type: MissionType
    sub_missions: List[SubMission]
    start_reason: StartReasonType
    end_reason: EndReasonType
    start_time: datetime
    end_time: datetime

    @staticmethod
    def from_dict(data_dct):
        data_dct['sub_missions'] = [SubMission(**sub_mission_data) for sub_mission_data in data_dct['sub_missions']]
        return Mission(**data_dct)

    def to_dict(self):
        return {
            'mission_type': self.mission_type,
            'sub_missions': [sub_mission.to_dict() for sub_mission in self.sub_missions],
            'start_reason': self.start_reason,
            'end_reason': self.end_reason,
            'start_time': self.start_time,
            'end_time': self.end_time
        }


@dataclass
class GoToWaypointMission(SubMission):
    lat_to_go: float
    lon_to_go: float

    @staticmethod
    def from_dict(data_dct):
        return GoToWaypointMission(**data_dct)

    def to_dict(self):
        dct = super().to_dict()
        dct['lat_to_go'] = self.lat_to_go
        dct['lon_to_go'] = self.lon_to_go
        return dct
