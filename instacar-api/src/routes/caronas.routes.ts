import { Router } from "express";
import caronaController from "../controllers/carona.controller";
import authMiddleware from "../middlewares/Auth";

const caronaRoutes = Router();

/**
 * @swagger
 * /caronas:
 *   get:
 *     summary: Retrieve a list of all caronas
 *     tags: [Caronas]
 *     responses:
 *       200:
 *         description: A list of caronas
 *   post:
 *     summary: Create a new carona
 *     tags: [Caronas]
 *     security:
 *       - BearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateCaronaDTO'
 *     responses:
 *       201:
 *         description: Carona created successfully
 *
 * /caronas/{id}:
 *   get:
 *     summary: Retrieve a specific carona by ID
 *     tags: [Caronas]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: The carona ID
 *     responses:
 *       200:
 *         description: A specific carona
 *   delete:
 *     summary: Delete a specific carona by ID
 *     tags: [Caronas]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: The carona ID
 *     responses:
 *       200:
 *         description: Carona deleted successfully
 *   put:
 *     summary: Update a specific carona by ID
 *     tags: [Caronas]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: The carona ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateCaronaDTO'
 *     responses:
 *       200:
 *         description: Carona updated successfully
 *
 * /caronas/near/{latitude}/{longitude}:
 *   get:
 *     summary: Retrieve caronas near a specific location
 *     tags: [Caronas]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: latitude
 *         required: true
 *         schema:
 *           type: number
 *         description: Latitude of the location
 *       - in: path
 *         name: longitude
 *         required: true
 *         schema:
 *           type: number
 *         description: Longitude of the location
 *     responses:
 *       200:
 *         description: A list of nearby caronas
 *
 * /caronas/{id}/{status}:
 *   put:
 *     summary: Update the status of a specific carona by ID
 *     tags: [Caronas]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: The carona ID
 *       - in: path
 *         name: status
 *         required: true
 *         schema:
 *           type: string
 *         description: The new status of the carona
 *     responses:
 *       200:
 *         description: Carona status updated successfully
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     CreateCaronaDTO:
 *       type: object
 *       properties:
 *         origem:
 *           type: string
 *           description: Origin of the carona
 *         destino:
 *           type: string
 *           description: Destination of the carona
 *         dataHora:
 *           type: string
 *           format: date-time
 *           description: Date and time of the carona
 *         vagas:
 *           type: integer
 *           description: Number of available seats
 *         status:
 *           type: string
 *           enum: ["disponível", "lotada", "finalizada"]
 *           description: Status of the carona
 *         origem_lat:
 *           type: number
 *           description: Latitude of the origin
 *         origem_lon:
 *           type: number
 *           description: Longitude of the origin
 *         destino_lat:
 *           type: number
 *           description: Latitude of the destination
 *         destino_lon:
 *           type: number
 *           description: Longitude of the destination
 */

caronaRoutes.get("/", caronaController.getCaronas);

caronaRoutes.get("/:id", caronaController.getCaronaById);

caronaRoutes.get("/near/:latitude/:longitude", authMiddleware, caronaController.getNearCaronas);

caronaRoutes.post("/", authMiddleware, caronaController.createCarona);

caronaRoutes.delete("/:id", authMiddleware, caronaController.deleteCarona);

caronaRoutes.put("/:id", authMiddleware, caronaController.updateCarona);

caronaRoutes.put("/:id/:status", authMiddleware, caronaController.updateCaronaStatus);

export default caronaRoutes;
