# task-xm-robotfw-july22

Python+Robot Framework project for a tasks from XM company.

---

Recommended Python version: 3.10.5

Python packages used: Robot Framework 5.0.1, FastAPI 0.78.0, Uvicorn 0.18.2.

To start please install a fittable Python version and install packages from requirements.txt to your environment.

Then you can start testing process with command like this: `robot \*.suite.robot`

---

Task #1 - Functional test suite - `api.suite.robot`

Task #2 - Performance test suite - `perf.suite.robot`

---

**API mock**

API mock can be started with command: `uvicorn mocksrv.main:mock --log-config mocksrv/logger.ini`

Standart mock address: http://127.0.0.1:8000/

Log file will appear in project root folder as `mocksrv.log` file.

Live documentation can be found here (_if standart address used_): http://127.0.0.1:8000/docs

---

Have fun. Feedback will be appreciated.
