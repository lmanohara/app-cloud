/*
* Copyright (c) 2015, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package org.wso2.appcloud.tierapi.server;

import java.sql.SQLException;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.wso2.appcloud.tierapi.bean.ContainerSpecifications;
import org.wso2.appcloud.tierapi.dao.impl.ContainerSpecDaoImpl;
import org.wso2.appcloud.tierapi.delegate.DAOdelegate;

@Path("/containerSpecs")
public class ContainerSpecSrvice {
    
    private ContainerSpecDaoImpl ContainerSpecInstance= (ContainerSpecDaoImpl) DAOdelegate.getContainerSpecInstance();
    
    /*
     * Get all Plans
     * @return                  Return all plans
     */
    @GET
    @Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
    public List<ContainerSpecifications> getPlans() throws SQLException {
        
        return ContainerSpecInstance.getAllContainerSpecs();
    }

    /*
     * Get Plan using Plan ID
     * @param planId            Plan ID of the plan
     * @return                  Return the plan refer to the Plan ID
     */
    @GET
    @Path("/{containerSpecId}")
    @Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
    public ContainerSpecifications getPlan(@PathParam("containerSpecId") int containerSpecId) throws SQLException {
        
        return ContainerSpecInstance.getContainerSpecById(containerSpecId);
    }

    /*
     * Get Plan using Plan ID
     * @param planId            Plan ID of the plan
     * @return                  Return the plan refer to the Plan ID
     */
    @GET
    @Path("allowedruntime/{containerSpecId}")
    @Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
    public ContainerSpecifications getPlanbyRuntimeId(@PathParam("containerSpecId") int runtimeId) throws SQLException {

        return ContainerSpecInstance.getContainerSpecByRuntimeID(runtimeId);
    }

}
